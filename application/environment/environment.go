package environment

import "os"

type Environment struct {
	Profile            string
	APIKey             string
	ResourceBaseURL    string
	ResourceBucketName string
	DistributionID     string
	AllowedOrigins     string
}

func (e *Environment) SetReactionAWSProfile(defaultValue string) {
	e.Profile = defaultValue
	if val, exists := os.LookupEnv("REACTION_AWS_PROFILE"); exists {
		e.Profile = val
	}
}

func (e *Environment) SetAPIKey(defaultValue string) {
	e.APIKey = defaultValue
	if val, exists := os.LookupEnv("API_KEY"); exists {
		e.APIKey = val
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

func (e *Environment) SetDistributionID(defaultValue string) {
	e.DistributionID = defaultValue
	if val, exists := os.LookupEnv("FRONT_DISTRIBUTION_ID"); exists {
		e.DistributionID = val
	}
}

func (e *Environment) SetAllowedOrigins(defaultValue string) {
	e.AllowedOrigins = defaultValue
	if val, exists := os.LookupEnv("ALLOWED_ORIGINS"); exists {
		e.AllowedOrigins = val
	}
}
