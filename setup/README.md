# macOS セットアップ自動化

新しい MacBook を受け取ったときに、開発環境を再現するための自動化スクリプトです。

## 前提条件

- macOS (Apple Silicon / Intel 両対応)
- インターネット接続
- `~/dotfiles` リポジトリがクローン済みであること

### dotfiles の期待するディレクトリ構造

```
~/dotfiles/
├── zsh/
│   ├── .zshrc
│   ├── .zshenv
│   └── .zprofile
├── mise/               # mise 設定ディレクトリ
├── nvim/               # Neovim 設定ディレクトリ
└── shell/
    ├── starship.toml
    ├── sheldon/        # sheldon 設定ディレクトリ (plugins.toml など)
    └── .wezterm.lua
```

> dotfiles が存在しない項目はスキップされます。sheldon だけはデフォルトの `plugins.toml` を自動生成します。

---

## 使い方

```bash
# 通常実行
bash ~/path/to/setup.sh

# dry run (実際のインストールは行わず、実行予定のコマンドを表示のみ)
bash ~/path/to/setup.sh --dry-run
bash ~/path/to/setup.sh -n        # 短縮形
```

初回実行時は sudo パスワードの入力を求められる場合があります（Homebrew インストール時）。

> **dry run について**
> `--dry-run` を付けると、すでにインストール済みかどうかのチェックをスキップしてすべての手順を表示します。
> `[DRY]` と表示された行は実際には実行されません。事前に何がインストールされるかを確認するのに使います。

---

## セットアップ内容

### ステップ一覧

| # | 内容 |
|---|------|
| 1 | Homebrew インストール |
| 2 | Homebrew Formulae インストール |
| 3 | Homebrew Casks インストール |
| 4 | zsh 設定ファイルのシンボリックリンク |
| 5 | mise セットアップ & ランタイムインストール |
| 6 | starship インストール & シンボリックリンク |
| 7 | sheldon セットアップ & プラグインインストール |
| 8 | wezterm シンボリックリンク |
| 9 | Neovim シンボリックリンク |
| 10 | gemini-cli インストール (node 経由) |
| 11 | Claude Code インストール |

---

### Homebrew Formulae

| パッケージ | 用途 |
|-----------|------|
| `git` | バージョン管理 |
| `zsh` | シェル |
| `neovim` | テキストエディタ |
| `tmux` | ターミナルマルチプレクサ |
| `mise` | ランタイムバージョン管理 |
| `sheldon` | zsh プラグインマネージャ |
| `lazygit` | TUI Git クライアント |
| `fzf` | ファジーファインダー |
| `fd` | 高速ファイル検索 |
| `jq` | JSON プロセッサ |
| `glow` | Markdown ビューア (CLI) |
| `yazi` | TUI ファイルマネージャ |
| `mas` | Mac App Store CLI |
| `tree` | ディレクトリツリー表示 |
| `tree-sitter` | 構文解析ライブラリ |
| `z` | ディレクトリジャンプ |
| `docker` | コンテナランタイム (CLI) |

#### yazi の依存関係 (自動インストール)

| パッケージ | 用途 |
|-----------|------|
| `ffmpeg` | 動画・音声プレビュー |
| `imagemagick` | 画像プレビュー |
| `poppler` | PDF プレビュー |
| `unar` | アーカイブ展開 |

---

### Homebrew Casks

| パッケージ | 用途 |
|-----------|------|
| `alt-tab` | Alt+Tab ウィンドウスイッチャー |
| `claude` | Claude デスクトップアプリ |
| `cmux` | tmux セッション管理 GUI |
| `dbeaver-community` | データベース GUI クライアント |
| `figma` | デザインツール |
| `font-code-new-roman-nerd-font` | Nerd Font |
| `font-fira-code-nerd-font` | Nerd Font |
| `font-hack-nerd-font` | Nerd Font |
| `ghostty` | ターミナルエミュレータ |
| `google-chrome` | ブラウザ |
| `google-japanese-ime` | 日本語入力 |
| `karabiner-elements` | キーリマッパー |
| `keycastr` | キーストローク表示 |
| `notion` | ノートアプリ |
| `notion-calendar` | カレンダー |
| `notion-mail` | メール |
| `obsidian` | ナレッジベース |
| `orbstack` | 軽量 Docker/VM 環境 |
| `postman` | API クライアント |
| `raycast` | ランチャー |
| `shortcat` | キーボード操作拡張 |
| `slack` | チャット |
| `spotify` | 音楽 |
| `visual-studio-code` | コードエディタ |
| `zoom` | ビデオ会議 |
| `docker-desktop` | Docker GUI |

---

### mise ランタイム

| ランタイム | バージョン |
|-----------|-----------|
| Go | latest |
| AWS CLI | latest |
| Bun | latest |
| docker-compose | latest |
| gcloud | latest |
| golangci-lint | latest, 1.64.6 |
| Lua | latest |
| marp-cli | latest |
| Node.js | 24.14.1, 22.26.0, 20.20.2 |
| pnpm | latest |
| Python | latest |
| Terraform | latest |
| Yarn | 1.22.22, 4.9.4 |

---

### sheldon プラグイン

| プラグイン | 用途 |
|-----------|------|
| `zsh-users/zsh-completions` | 補完強化 |
| `zsh-users/zsh-syntax-highlighting` | シンタックスハイライト |
| `romkatv/zsh-defer` | 遅延読み込み |

---

### その他のツール

| ツール | インストール方法 |
|-------|----------------|
| starship | `curl -sS https://starship.rs/install.sh \| sh` |
| gemini-cli | `npm install -g @google/gemini-cli` |
| Claude Code | `curl -fsSL https://claude.ai/install.sh \| bash` |

---

## シンボリックリンク一覧

| リンク先 | ソース |
|---------|--------|
| `~/.zshrc` | `~/dotfiles/zsh/.zshrc` |
| `~/.zshenv` | `~/dotfiles/zsh/.zshenv` |
| `~/.zprofile` | `~/dotfiles/zsh/.zprofile` |
| `~/.config/mise` | `~/dotfiles/mise` |
| `~/.config/starship.toml` | `~/dotfiles/shell/starship.toml` |
| `~/.config/sheldon` | `~/dotfiles/shell/sheldon` |
| `~/.config/.wezterm.lua` | `~/dotfiles/shell/.wezterm.lua` |
| `~/.config/nvim` | `~/dotfiles/nvim` |

---

## ログの見方

スクリプト実行中は以下のプレフィックスで状態を確認できます。

```
[RUN]   実行中の処理
[DRY]   dry run のためスキップ (--dry-run 時のみ)
[OK]    成功
[SKIP]  すでにインストール済みのためスキップ
[INFO]  補足情報
[ERROR] エラー (処理は継続)
```

---

## 注意事項

- **冪等性**: すでにインストール済みのものはスキップされるため、途中で失敗しても再実行できます。
- **バックアップ**: シンボリックリンク作成時に既存ファイルが存在する場合、`.bak.日時` にリネームしてから置換します。
- **Apple Silicon**: `/opt/homebrew` のパスを自動で設定します。Intel Mac では `/usr/local` を使用します。
- **`cmux`**: Homebrew Cask の正式名を事前に確認してください。見つからない場合は `brew search cmux` で確認を。
- **mise の一部プラグイン**: `gcloud`、`marp-cli`、`docker-compose` は初回インストール時に `mise plugin add` が自動実行されますが、失敗した場合は手動で追加してください。

```bash
mise plugin add gcloud
mise plugin add marp-cli
mise plugin add docker-compose
```

---

## セットアップ後の手順

1. ターミナルを再起動するか `source ~/.zshrc` を実行
2. Google Japanese IME を入力ソースに追加 (システム設定 > キーボード)
3. Karabiner-Elements で設定ファイルを読み込む
4. `mise use --global node@24.14.1` などでデフォルトランタイムを設定
5. OrbStack / Docker Desktop を起動して動作確認
6. Raycast の設定とライセンス認証
