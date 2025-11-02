package handler

import (
	"errors"
	"strings"
)

func checkAuthHeader(authHeader string, apiKey string) error {
	if authHeader == "" {
		return errors.New("missing Authorization header")
	}

	// "Bearer " を外して APIキーだけを取り出す
	const prefix = "Bearer "
	if !strings.HasPrefix(authHeader, prefix) {
		return errors.New("invalid Authorization header format")
	}

	if apiKey != strings.TrimPrefix(authHeader, prefix) {
		return errors.New("mismatch")
	}
	return nil
}
