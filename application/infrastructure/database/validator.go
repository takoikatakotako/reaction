package database

import (
	"github.com/google/uuid"
	"strings"
)

func IsValidUUID(u string) bool {
	_, err := uuid.Parse(u)
	return err == nil
}

func IsValidUUIDImageName(imageName string) bool {
	name := strings.TrimSuffix(imageName, ".png")
	return IsValidUUID(name)
}
