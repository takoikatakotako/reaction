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

// distributionID が空のときの扱い。
// ローカルには CloudFront が無いのでスキップするが、非 local で空なのは
// 環境変数の設定漏れなので、黙って成功扱いにせずエラーにする。
func TestCreateInvalidationWithEmptyDistributionID(t *testing.T) {
	local := AWS{Profile: "local"}
	assert.NoError(t, local.CreateInvalidation("", []string{"/resource/*"}))

	production := AWS{Profile: ""}
	assert.Error(t, production.CreateInvalidation("", []string{"/resource/*"}))

	named := AWS{Profile: "reaction-production"}
	assert.Error(t, named.CreateInvalidation("", []string{"/resource/*"}))
}
