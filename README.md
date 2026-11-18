# 🚀 Dotfiles (Mise Modern Architecture)

このリポジトリは `mise tasks` と `age` 暗号化を活用した、完全自動化かつモダンなドットファイル管理システムです。

## 🏗️ 構成とアーキテクチャ

- **`bootstrap.sh`**: 最初の起点。OS判定からHomebrew、miseの導入までを全自動で行います。
- **`mise-tasks/`**: `mise run setup` で呼び出される実作業スクリプト群（依存関係に応じて並列実行）。
  - `link`: `symlinks.toml` を読み込み、安全（バックアップ付き）にシンボリックリンクを展開。
  - `brew`: `Brewfile` に基づきパッケージを導入。
  - `tools`: グローバルCLIツール群を導入。
  - `secrets`: `age` 鍵を用いて暗号化済みのシークレットファイル（`.gitconfig*` など）を復号。
  - `post_install`: `sheldon` プラグイン更新、npm/uv ツール導入、`ai-sync` の実行など事後処理。
  - `macos`: macOS のシステム設定（Dock・キーボード・トラックパッドの `defaults`）を適用（macOS のみ）。
  - `ai-sync`: `ai/ai-sync.json` に基づき Claude Code / Antigravity (`agy`) / Codex のプラグインと MCP サーバーを同期。
  - `doctor`: シンボリックリンク、`age` 鍵権限、必須ツール、JSON 構文、Zsh 起動時間を診断。
- **`mise/conf.d/`**: グローバル設定をクリーンに分割管理するためのディレクトリ（`tools.toml`, `settings.toml`, `env.toml`, `symlinks.toml`）。
- **`.github/workflows/ci.yml`**: ShellCheck / bash・zsh 構文 / JSON / Python スクリプトを自動検証する CI。

---

## 💻 新しいPCでのセットアップ手順

新しいMacやLinux（WSL）を購入した際は、以下の手順でセットアップを行います。

### Step 1: 秘密鍵（age）の配置
シークレット環境変数を復号するための秘密鍵を、一番最初に配置します。
（※この鍵は1PasswordやUSB等の安全な場所からコピーしてきてください）

```bash
mkdir -p ~/.config/mise
# エディタで開いて鍵をペースト
nano ~/.config/mise/dotfiles-age.txt
# 権限を厳格化
chmod 600 ~/.config/mise/dotfiles-age.txt
```

### Step 2: リポジトリのクローンと起動
```bash
cd ~
git clone https://github.com/maresuke3/dotfiles.git
cd dotfiles
./bootstrap.sh
```
> 💡 `./bootstrap.sh` が終わると、自動的にすべてのツール、リンク、環境変数、AIエージェント設定が展開されます。

### Step 3: 手動認証（SSO / ブラウザログイン）
セキュリティ上、Gitには含めていないクラウドプロバイダやAIエージェント等の認証を行います。

```bash
# AWSの認証
aws configure sso  # または aws configure

# Google Cloudの認証
gcloud auth login

# GitHubの認証
gh auth login

# AI CLI / MCP 関連の初回認証（必要に応じて）
claude        # Claude Code ログイン・MCP OAuth 認証
codex login   # Codex CLI ログイン
```

---

## 🛠️ 日々の運用コマンド

### ツールの追加
`mise use -g` は使わず、エイリアスの `mguse` を使用します（`tools.toml` に安全に書き込むため）。
```bash
mguse node@20
```

### シークレット変数の追加
`age` で暗号化して `mise/conf.d/env.toml` に追加します。
```bash
mise set --path ~/dotfiles/mise/conf.d/env.toml --age-encrypt SECRET_TOKEN=super_secret
```

### AI エージェント（プラグイン / MCP）の同期
`ai/ai-sync.json` を編集したあと、手動で同期したい場合に実行します。
```bash
mise run ai-sync           # 同期実行
mise run ai-sync --dry-run # 変更内容の確認のみ
```

### macOS システム設定の反映
`mise-tasks/macos` を編集したあと、macOS の `defaults` 設定を再適用したい場合に実行します。
```bash
mise run macos             # 適用
mise run macos --dry-run   # 実行内容の確認のみ
```

### Zsh キャッシュのリフレッシュ
ツールや補完を更新・削除したあと、Zsh の補完キャッシュ・`init` キャッシュを作り直したいときに実行します。
```bash
zsh-refresh-cache --reload
```

---

## 🖥️ Windows (WSL) 固有のセットアップ

### WezTerm の設定ファイル連動
WSL環境では、Windows側にインストールした WezTerm（`.exe`）をメインのターミナルとして利用します。
Windows側の WezTerm から WSL内の `wezterm.lua` を読み込ませるため、Windows側の設定ファイルに以下の1行を記述してください。

**配置場所 (Windows側):** `C:\Users\<ユーザー名>\.config\wezterm\wezterm.lua`
```lua
-- WSL上のdotfiles内にある設定ファイルを動的にロードする
return dofile("\\\\wsl.localhost\\Ubuntu\\home\\<ユーザー名>\\dotfiles\\config\\wezterm\\wezterm.lua")
```
*(※ `<ユーザー名>` や `Ubuntu` の部分はご自身の環境に合わせて適宜変更してください)*
