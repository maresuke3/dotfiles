# 🚀 Dotfiles (Mise Modern Architecture)

このリポジトリは `mise tasks` と `age` 暗号化を活用した、完全自動化かつモダンなドットファイル管理システムです。

## 🏗️ 構成とアーキテクチャ

- **`bootstrap.sh`**: 最初の起点。OS判定からHomebrew、miseの導入までを全自動で行います。
- **`mise-tasks/`**: `mise run setup` で呼び出される実作業スクリプト群（並列実行）。
  - `link`: `symlinks.toml` を読み込み、安全（バックアップ付き）にシンボリックリンクを展開。
  - `brew`: `Brewfile` に基づきパッケージを導入。
  - `tools`: グローバルCLIツール群を導入。
  - `post_install`: npmグローバルや設定のリロードなど事後処理。
- **`mise/conf.d/`**: グローバル設定をクリーンに分割管理するためのディレクトリ（`tools.toml`, `settings.toml`, `symlinks.toml`）。

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
git clone https://github.com/あなたのユーザー名/dotfiles.git
cd dotfiles
./bootstrap.sh
```
> 💡 `./bootstrap.sh` が終わると、自動的にすべてのツール、リンク、環境変数が展開されます。

### Step 3: 手動認証（SSO / ブラウザログイン）
セキュリティ上、Gitには含めていないクラウドプロバイダ等の認証を行います。

```bash
# AWSの認証
aws configure sso  # または aws configure

# Google Cloudの認証
gcloud auth login

# GitHubの認証
gh auth login
```

---

## 🛠️ 日々の運用コマンド

### ツールの追加
`mise use -g` は使わず、エイリアスの `mguse` を使用します（`tools.toml` に安全に書き込むため）。
```bash
mguse node@20
```

### シークレット変数の追加
`age` で暗号化して追加します。
```bash
mise set --age-encrypt SECRET_TOKEN=super_secret
```

## 🖥️ Windows (WSL) 固有のセットアップ

### WezTerm の設定ファイル連動
WSL環境では、Windows側にインストールした WezTerm（`.exe`）をメインのターミナルとして利用します。
Windows側の WezTerm から WSL内の `wezterm.lua` を読み込ませるため、Windows側の設定ファイルに以下の1行を記述してください。

**配置場所 (Windows側):** `C:\Users\<ユーザー名>\.config\wezterm\wezterm.lua`
```lua
-- WSL上のdotfiles内にある設定ファイルを動的にロードする
dofile("\\\\wsl.localhost\\Ubuntu\\home\\maresuke\\dotfiles\\shell\\wezterm\\wezterm.lua")
```
*(※ `maresuke` や `Ubuntu` の部分はご自身の環境に合わせて適宜変更してください)*

