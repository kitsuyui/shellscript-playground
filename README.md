# shellscript-playground

## ja: 概要

このリポジトリは、シェルスクリプトの練習・実験用のリポジトリです。
雑多なスクリプトが入っています。今までに書いたスクリプトを整理してここに移していく予定です。
POSIX シェルで動作することを好みますが、合理的な範囲での努力のみで済ませ、 bash や zsh に依存することもあります。
その場合もなるべく shebang を `#!/usr/bin/env bash` で書くことにして環境の違いを吸収するようにしています。

また、 BSD 系のコマンドと GNU 系のコマンドの違いも合理的な範囲でのみ考慮することにします。
しかし、互換性のために多すぎる努力をすることは避け、コメントで補うことにします。

可能ならばテストを書くようにします。

## en: Description

This repository is for practicing and experimenting with shell scripts.
It contains various scripts. I will organize the scripts I have written so far and move them here.
I prefer that the scripts work with POSIX shell, but I also depend on bash and zsh within a reasonable range of effort.
In that case, I try to write the shebang as `#!/usr/bin/env bash` as much as possible to absorb the differences in the environment.

Also, I will only consider the differences between BSD and GNU commands within a reasonable range of effort.
However, I will avoid making too much effort for compatibility and supplement it with comments.

If possible, I will write tests.

## ja: 依存関係

`generate-web-icons` は ImageMagick 7 の `magick` と ImageMagick 6 の `convert` をサポートします。
`magick` が存在する場合は優先して使い、 Ubuntu の `imagemagick` パッケージとこのリポジトリの CI ベースラインが ImageMagick 6 を提供している間は `convert` のフォールバックを維持します。

## en: Dependencies

`generate-web-icons` supports ImageMagick 7 through `magick` and ImageMagick 6 through `convert`.
It prefers `magick` when available, and keeps the `convert` fallback while Ubuntu's `imagemagick` package and this repository's CI baseline provide ImageMagick 6.

## Installation

```bash
git clone git@github.com:kitsuyui/shellscript-playground.git
```

Add the following to your `.bashrc` or `.zshrc`:

```bash
export PATH="$PATH:/path/to/shellscript-playground/bin"
```

## Development

Install [lefthook](https://github.com/evilmartians/lefthook) and then run:

```bash
lefthook install
```

This sets up the following Git hooks:

- **pre-commit**: runs `./tests/shfmt.sh` (format check) and `./tests/shellcheck.sh` (lint)
- **pre-push**: runs `./tests/shfmt.sh`, `./tests/shellcheck.sh`, and `./tests/all.sh` (full test suite)

CI runs the full suite (`shfmt`, `shellcheck`, and `all.sh`) on every pull request.

## LICENSE

MIT License
