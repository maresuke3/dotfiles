"""Apply the dotfiles-managed Serena settings to ~/.serena/serena_config.yml.

Only the keys in serena_config.managed.yml are overwritten. Everything else, including
the machine-local keys Serena writes at runtime (auth_secret, projects, ...), is kept,
so the global config can't be a symlink into dotfiles: Serena saves it via os.replace,
which would replace the link, and it holds a secret.

Run it with Serena's own interpreter, which ships ruamel.yaml:
    "$(uv tool dir)/serena-agent/bin/python" -I ~/dotfiles/serena/apply_config.py
"""

import os
import sys
import tempfile
from pathlib import Path

from ruamel.yaml import YAML

MANAGED_PATH = Path(__file__).resolve().with_name("serena_config.managed.yml")
CONFIG_PATH = Path(os.environ.get("SERENA_HOME") or Path.home() / ".serena") / "serena_config.yml"


def main() -> int:
    if not CONFIG_PATH.is_file():
        print(f"{CONFIG_PATH} not found; run `serena init` first", file=sys.stderr)
        return 1

    yaml = YAML()  # round-trip mode keeps comments and key order
    yaml.preserve_quotes = True
    managed = yaml.load(MANAGED_PATH) or {}
    config = yaml.load(CONFIG_PATH)

    changed = [key for key, value in managed.items() if config.get(key) != value]
    if not changed:
        print("Serena config already up to date.")
        return 0

    for key in changed:
        config[key] = managed[key]

    # Write atomically like Serena does, keeping the file private (it holds auth_secret).
    fd, tmp = tempfile.mkstemp(dir=CONFIG_PATH.parent, prefix=CONFIG_PATH.name + ".", suffix=".tmp")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            yaml.dump(config, f)
        os.chmod(tmp, 0o600)
        os.replace(tmp, CONFIG_PATH)
    except BaseException:
        os.unlink(tmp)
        raise

    print("Serena config updated: " + ", ".join(changed))
    return 0


if __name__ == "__main__":
    sys.exit(main())
