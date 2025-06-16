package handler

import (
	"errors"
	"fmt"
	"strings"
)

func checkAuthHeader(authHeader string, apiKey string) error {
	text := fmt.Sprintf("AuthHeader: %s, API Key: %s\n", authHeader, apiKey)
	fmt.Println(text)
	
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
