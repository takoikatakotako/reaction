package main

type Reaction struct {
	DirectoryName   string           `json:"directoryName"`
	English         string           `json:"english"`
	Japanese        string           `json:"japanese"`
	ThmbnailName    string           `json:"thmbnailName"`
	GeneralFormulas []GeneralFormula `json:"generalFormulas"`
	Mechanisms      []Mechanism      `json:"mechanisms"`
	Examples        []Example        `json:"examples"`
	Supplements     []Supplement     `json:"supplements"`
	Suggestions     []string         `json:"suggestions"`
	Tags            []string         `json:"tags"`
	Reactants       []string         `json:"reactants"`
	Products        []string         `json:"products"`
	YoutubeLinks    []string         `json:"youtubeLinks"`
}

type GeneralFormula struct {
	ImageName string `json:"imageName"`
}

type Mechanism struct {
	ImageName string `json:"imageName"`
}

type Example struct {
	ImageName string `json:"imageName"`
}

type Supplement struct {
	ImageName string `json:"imageName"`
}
