package environment

import "os"

type Environment struct {
	Profile            string
	ResourceBaseURL    string
	ResourceBucketName string
}

func (e *Environment) SetReactionAWSProfile(defaultValue string) {
	e.Profile = defaultValue
	if val, exists := os.LookupEnv("REACTION_AWS_PROFILE"); exists {
		e.Profile = val
	}
}

func (e *Environment) SetResourceBaseURL(defaultValue string) {
	e.ResourceBaseURL = defaultValue
	if val, exists := os.LookupEnv("RESOURCE_BASE_URL"); exists {
		e.ResourceBaseURL = val
	}
}

func (e *Environment) SetResourceBucketName(defaultValue string) {
	e.ResourceBucketName = defaultValue
	if val, exists := os.LookupEnv("RESOURCE_BUCKET_NAME"); exists {
		e.ResourceBucketName = val
	}
}
