package main

import (
	"bytes"
	"encoding/json"
	"log/slog"
	"testing"
)

func TestSetupLoggerOutputsJSON(t *testing.T) {
	var buf bytes.Buffer
	setupLogger(&buf)

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
	setupLogger(&buf)

	slog.Debug("デバッグログは出力しない")

	if buf.Len() != 0 {
		t.Errorf("Debug レベルが出力されています: %q", buf.String())
	}
}
