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
    """Markdown を HTML にする。

    入れ子のリストを保つ。平坦化すると、条文の途中に箇条書きを挟んだときに
    そのあとの項番号が 1 に戻ってしまう。
    """
    out = []
    # 開いているリストの (インデント, タグ)。深い順に積む。
    stack = []
    # 現在の階層で <li> が開いているか
    li_open = False

    def pad(depth):
        return "      " + "  " * depth

    def close_li():
        nonlocal li_open
        if li_open:
            out.append(pad(len(stack)) + "</li>")
            li_open = False

    def close_lists(min_indent=-1):
        nonlocal li_open
        while stack and stack[-1][0] > min_indent:
            close_li()
            _, tag = stack.pop()
            out.append(pad(len(stack)) + f"</{tag}>")
            # 親の <li> は開いたままなので、閉じる担当を引き継ぐ
            li_open = bool(stack)
        if not stack:
            li_open = False

    def add_item(indent, tag, text):
        nonlocal li_open
        # 浅くなったぶんだけ閉じる
        while stack and indent < stack[-1][0]:
            close_lists(stack[-1][0] - 1)

        if stack and indent == stack[-1][0]:
            if stack[-1][1] != tag:
                # 同じ深さで種類が変わったら開き直す
                close_lists(indent - 1)
            else:
                close_li()

        if not stack or indent > stack[-1][0]:
            # 親の <li> の中に入れ子のリストを開く
            out.append(pad(len(stack) + 1) + f"<{tag}>")
            stack.append((indent, tag))
            li_open = False

        out.append(pad(len(stack)) + f"<li>{inline(text)}")
        li_open = True

    for raw in md.split("\n"):
        line = raw.rstrip()
        stripped = line.strip()
        indent = len(line) - len(line.lstrip())

        ordered = re.match(r"^\s*\d+\. (.*)$", line)
        bullet = re.match(r"^\s*- (.*)$", line)

        if not stripped:
            close_lists()
        elif ordered:
            add_item(indent, "ol", ordered.group(1))
        elif bullet:
            add_item(indent, "ul", bullet.group(1))
        elif stripped == "---":
            close_lists()
            out.append("      <hr>")
        elif stripped == "以上":
            close_lists()
            out.append('      <p class="end">以上</p>')
        elif line.startswith("# "):
            close_lists()
            out.append(f"      <h1>{inline(line[2:])}</h1>")
        elif line.startswith("## "):
            close_lists()
            out.append(f"      <h2>{inline(line[3:])}</h2>")
        else:
            close_lists()
            out.append(f"      <p>{inline(stripped)}</p>")

    close_lists()
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
