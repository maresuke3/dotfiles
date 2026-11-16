"""Apply dotfiles-managed Codex settings from ai/codex/config.toml to ~/.codex/config.toml.

Only the keys/sections defined in ai/codex/config.toml are overwritten. Machine-local
sections written by Codex at runtime (mcp_servers, projects, tui, ...) are preserved,
so ~/.codex/config.toml stays a real file rather than a symlink into dotfiles.
"""

import json
import os
import re
import sys
import tempfile
import tomllib
from pathlib import Path
from typing import Any

MANAGED_PATH = Path(__file__).resolve().with_name("config.toml")
CONFIG_PATH = Path(os.environ.get("CODEX_HOME") or Path.home() / ".codex") / "config.toml"
BARE_KEY_RE = re.compile(r"^[A-Za-z0-9_-]+$")


def _fmt_key(key: str) -> str:
    return key if BARE_KEY_RE.match(key) else json.dumps(key)


def _fmt_value(val: Any) -> str:
    if isinstance(val, bool):
        return "true" if val else "false"
    if isinstance(val, (int, float)):
        return str(val)
    if isinstance(val, str):
        return json.dumps(val)
    if isinstance(val, list):
        return "[" + ", ".join(_fmt_value(v) for v in val) + "]"
    if isinstance(val, dict):
        items = ", ".join(f"{_fmt_key(k)} = {_fmt_value(v)}" for k, v in val.items())
        return "{ " + items + " }"
    raise TypeError(f"Unsupported TOML value type: {type(val).__name__}")


def _dump_toml(data: dict[str, Any]) -> str:
    lines: list[str] = []

    def emit_table(table: dict[str, Any], prefix: list[str]) -> None:
        scalars = [(k, v) for k, v in table.items() if not isinstance(v, dict)]
        subtables = [(k, v) for k, v in table.items() if isinstance(v, dict)]

        if prefix and (scalars or not subtables):
            lines.append("[" + ".".join(_fmt_key(p) for p in prefix) + "]")
        for k, v in scalars:
            lines.append(f"{_fmt_key(k)} = {_fmt_value(v)}")
        if prefix and (scalars or not subtables):
            lines.append("")
        elif not prefix and scalars and subtables:
            lines.append("")

        for k, v in subtables:
            emit_table(v, [*prefix, k])

    emit_table(data, [])
    return "\n".join(lines).rstrip() + "\n"


def _deep_merge(base: dict[str, Any], override: dict[str, Any]) -> dict[str, Any]:
    merged = dict(base)
    for k, v in override.items():
        if isinstance(v, dict) and isinstance(merged.get(k), dict):
            merged[k] = _deep_merge(merged[k], v)
        else:
            merged[k] = v
    return merged


def main() -> int:
    managed = tomllib.loads(MANAGED_PATH.read_text(encoding="utf-8"))
    if CONFIG_PATH.is_file():
        current = tomllib.loads(CONFIG_PATH.read_text(encoding="utf-8"))
    else:
        current = {}

    merged = _deep_merge(current, managed)
    if not CONFIG_PATH.is_symlink() and merged == current:
        print("Codex config already up to date.")
        return 0

    rendered = _dump_toml(merged)
    # Verify round-trip before replacing ~/.codex/config.toml
    if tomllib.loads(rendered) != merged:
        raise RuntimeError("Generated TOML failed round-trip verification")

    if "--dry-run" in sys.argv:
        print("Codex config would be updated from ai/codex/config.toml.")
        return 0

    CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(dir=CONFIG_PATH.parent, prefix=CONFIG_PATH.name + ".", suffix=".tmp")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(rendered)
        os.chmod(tmp, 0o600)
        os.replace(tmp, CONFIG_PATH)
    except BaseException:
        os.unlink(tmp)
        raise

    print("Codex config updated from ai/codex/config.toml.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
