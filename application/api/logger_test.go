package main

import (
	"bytes"
	"encoding/json"
	"io"
	"log/slog"
	"testing"
)

// setupLogger はプロセス全体のデフォルトロガーを差し替えるため、
// 他のテストに影響しないようテスト終了時に元へ戻す
func setupLoggerForTest(t *testing.T, w io.Writer) {
	t.Helper()
	old := slog.Default()
	t.Cleanup(func() { slog.SetDefault(old) })
	setupLogger(w)
}

func TestSetupLoggerOutputsJSON(t *testing.T) {
	var buf bytes.Buffer
	setupLoggerForTest(t, &buf)

	slog.Error("something went wrong")

	var entry map[string]any
	if err := json.Unmarshal(buf.Bytes(), &entry); err != nil {
		t.Fatalf("ログが JSON として解釈できません: %v (出力: %q)", err, buf.String())
	}

	// CloudWatch Logs のフィルタ { $.level = "ERROR" } が一致する形式であること
	if entry["level"] != "ERROR" {
		t.Errorf("level が ERROR ではありません: %v", entry["level"])
	}
	if entry["msg"] != "something went wrong" {
		t.Errorf("msg が期待と異なります: %v", entry["msg"])
	}
	if _, ok := entry["time"]; !ok {
		t.Error("time が含まれていません")
	}
}

func TestSetupLoggerDropsDebugLevel(t *testing.T) {
	var buf bytes.Buffer
	setupLoggerForTest(t, &buf)

	slog.Debug("デバッグログは出力しない")

	if buf.Len() != 0 {
		t.Errorf("Debug レベルが出力されています: %q", buf.String())
	}
}
