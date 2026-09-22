package main

import (
	"io"
	"log/slog"
)

// setupLogger は slog のデフォルトロガーを JSON 出力に切り替える。
//
// CloudWatch Logs のメトリクスフィルタ / サブスクリプションフィルタは
// { $.level = "ERROR" } のような JSON パスで絞り込むため、
// slog のデフォルト（text ハンドラ）のままだとマッチしない。
func setupLogger(w io.Writer) {
	slog.SetDefault(slog.New(slog.NewJSONHandler(w, &slog.HandlerOptions{
		Level: slog.LevelInfo,
	})))
}
