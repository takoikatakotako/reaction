#!/usr/bin/env python3
"""lp/legal/*.md から法務ページの HTML を生成する。

原本は Markdown。差分が読めるのと、条文の追記が楽なため。
手で HTML を書くと、原本と表示が食い違ったときに追えなくなる。

出力は lp/ 直下（privacy.html / terms.html）。URL を短くするため
ディレクトリは掘らない。
"""

import html
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
SRC = ROOT / "legal"

TEMPLATE = """<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8">
    <title>{title} - シン反応機構</title>
    <meta name="description" content="{description}">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index, follow">
    <link rel="stylesheet" href="/css/legal.css">
  </head>
  <body>
    <header class="header">
      <a class="header__home" href="/">
        <img src="/images/icon.png" width="32" height="32" alt="">
        <span>シン反応機構</span>
      </a>
    </header>

    <main class="document">
{body}    </main>

    <footer class="footer">
      <a href="/privacy.html">プライバシーポリシー</a>
      <a href="/terms.html">利用規約</a>
    </footer>
  </body>
</html>
"""


def inline(text):
    """強調とリンクだけ対応する。法務文書に必要なのはこれだけ。"""
    text = html.escape(text, quote=False)
    text = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", text)

    def link(m):
        label, url = m.group(1), m.group(2)
        external = url.startswith("http")
        attrs = ' target="_blank" rel="noopener"' if external else ""
        return f'<a href="{html.escape(url, quote=True)}"{attrs}>{label}</a>'

    return re.sub(r"\[(.+?)\]\((.+?)\)", link, text)


def convert(md):
    out = []
    list_type = None

    def close_list():
        nonlocal list_type
        if list_type:
            out.append(f"      </{list_type}>")
            list_type = None

    def open_list(kind):
        nonlocal list_type
        if list_type != kind:
            close_list()
            out.append(f"      <{kind}>")
            list_type = kind

    for raw in md.split("\n"):
        line = raw.rstrip()
        stripped = line.strip()

        if not stripped:
            close_list()
        elif stripped == "---":
            close_list()
            out.append("      <hr>")
        elif stripped == "以上":
            close_list()
            out.append('      <p class="end">以上</p>')
        elif line.startswith("# "):
            close_list()
            out.append(f"      <h1>{inline(line[2:])}</h1>")
        elif line.startswith("## "):
            close_list()
            out.append(f"      <h2>{inline(line[3:])}</h2>")
        elif re.match(r"^\s*\d+\. ", line):
            open_list("ol")
            item = re.sub(r"^\s*\d+\. ", "", line)
            out.append(f"        <li>{inline(item)}</li>")
        elif re.match(r"^\s*- ", line):
            open_list("ul")
            item = re.sub(r"^\s*- ", "", line)
            out.append(f"        <li>{inline(item)}</li>")
        else:
            close_list()
            out.append(f"      <p>{inline(stripped)}</p>")

    close_list()
    return "\n".join(out) + "\n"


def main():
    pages = {
        "privacy": ("プライバシーポリシー", "シン反応機構が取得する情報とその取扱いについて。"),
        "terms": ("利用規約", "シン反応機構の利用条件について。"),
    }

    if not SRC.is_dir():
        sys.exit(f"error: {SRC} がありません")

    for name, (title, description) in pages.items():
        src = SRC / f"{name}.md"
        if not src.is_file():
            sys.exit(f"error: {src} がありません")

        page = TEMPLATE.format(
            title=html.escape(title, quote=True),
            description=html.escape(description, quote=True),
            body=convert(src.read_text(encoding="utf-8")),
        )
        dest = ROOT / f"{name}.html"
        dest.write_text(page, encoding="utf-8")
        print(f"{src.relative_to(ROOT.parent)} -> {dest.relative_to(ROOT.parent)}")


if __name__ == "__main__":
    main()
