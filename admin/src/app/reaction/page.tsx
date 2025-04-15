// app/about/page.tsx
export default function AboutPage() {
  return (
    <div>
      <div class="sub-cover">
        <header class="page-header wrapper">
          <h1 class="align-center">
            <a href="index.html">
              <p class="logo">シン反応機構管理画面</p>
            </a>
          </h1>
          <nav>
            <ul class="main-nav">
              <li>
                <a href="reaction.html" class="main-nav-active">
                  反応機構
                </a>
              </li>
              <li>
                <a href="review.html" class="main-nav-inactive">
                  学習問題
                </a>
              </li>
              <li>
                <a href="merchandise.html" class="main-nav-inactive">
                  略称一覧
                </a>
              </li>
              <li>
                <a href="report.html" class="main-nav-inactive">
                  報告
                </a>
              </li>
            </ul>
          </nav>
        </header>
      </div>
    </div>
  );
}
