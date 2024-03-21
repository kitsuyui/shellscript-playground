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

## Installation

```bash
git clone git@github.com:kitsuyui/shellscript-playground.git
```

Add the following to your `.bashrc` or `.zshrc`:

```bash
export PATH="$PATH:/path/to/shellscript-playground/bin"
```

## LICENSE

MIT License
