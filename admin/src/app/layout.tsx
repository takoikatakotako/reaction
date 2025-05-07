import type { Metadata } from 'next';
// import { Geist, Geist_Mono } from 'next/font/google';
import './reset.css';
import './globals.css';

export const metadata: Metadata = {
  title: 'シン有機化学管理画面',
  description: 'シン有機化学管理画面',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="ja">
      <body>
        <div className="sub-cover">
          <header className="page-header wrapper">
            <h1 className="align-center">
              <a href="/">
                <p className="logo">シン反応機構管理画面</p>
              </a>
            </h1>
            <nav>
              <ul className="main-nav">
                <li>
                  <a href="/reaction" className="main-nav-active">
                    反応機構
                  </a>
                </li>
                <li>
                  <a href="review.html" className="main-nav-inactive">
                    学習問題
                  </a>
                </li>
                <li>
                  <a href="merchandise.html" className="main-nav-inactive">
                    略称一覧
                  </a>
                </li>
                <li>
                  <a href="report.html" className="main-nav-inactive">
                    報告
                  </a>
                </li>
              </ul>
            </nav>
          </header>
        </div>

        {children}

        <footer>
          <div className="copyright">
            <small>&copy; swiswiswift.com</small>
          </div>
        </footer>
      </body>
    </html>
  );
}
