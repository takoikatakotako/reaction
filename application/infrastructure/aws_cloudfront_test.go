package infrastructure

import (
	"github.com/stretchr/testify/assert"
	"strings"
	"testing"
)

// CallerReference は distribution ごとに一意である必要がある。
// 秒精度のタイムスタンプだと 1 回のエクスポート内で衝突して
// InvalidArgument になるため、呼ぶたびに異なる値になること。
func TestCallerReferenceIsUniquePerCall(t *testing.T) {
	seen := make(map[string]bool)
	for i := 0; i < 100; i++ {
		ref := newInvalidationCallerReference()
		assert.True(t, strings.HasPrefix(ref, "invalidation-"))
		assert.False(t, seen[ref], "重複した CallerReference が生成された: %s", ref)
		seen[ref] = true
	}
	assert.Len(t, seen, 100)
}
