import nextCoreWebVitals from 'eslint-config-next/core-web-vitals';
import nextTypeScript from 'eslint-config-next/typescript';

// eslint-config-next 16 は flat config を直接エクスポートするため、
// FlatCompat 経由の extends は不要になった
const eslintConfig = [
  {
    ignores: ['.next/**', 'out/**', 'node_modules/**'],
  },
  ...nextCoreWebVitals,
  ...nextTypeScript,
  {
    // eslint-plugin-react の自動バージョン検出が設定ファイル自身の lint 時に
    // 失敗するため、明示的に指定する
    settings: {
      react: { version: '19.3' },
    },
  },
];

export default eslintConfig;
