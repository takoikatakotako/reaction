package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"sort"
	// "strconv"
)

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
	Tags     []string                `json:"tags"`
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

func main() {
	// ファイルを読み込み
	reactions := readReactionsFile("reactions.json")
	checkReactions(reactions)

	// Sort 
	reactions = sortReactions(reactions)
	exportReactions(reactions)
}

// 反応データを読み込む
func readReactionsFile(filePath string) []Reaction {
	jsonFile, err := os.Open(filePath)
	if err != nil {
		fmt.Println(err)
		panic("Fail to Opened reactions.json")
	}
	defer jsonFile.Close()

	byteValue, _ := ioutil.ReadAll(jsonFile)
	var reactions []Reaction
	json.Unmarshal(byteValue, &reactions)
	return reactions
}

// 構成周りで問題ないかチェック
func checkReactions(reactions []Reaction) {
	for i := 0; i < len(reactions); i++ {
		var directoryName string = reactions[i].DirectoryName
		var thmbnailName string = reactions[i].ThmbnailName
		var thmbnailPath string = "resource/" + directoryName + "/" + thmbnailName

		// Check Thmbnail
		if _, err := os.Stat(thmbnailPath); os.IsNotExist(err) {
			panic("Thmbnail Not Found, Path: " + thmbnailPath)
		}

		// Check General Formulas
		for j := 0; j < len(reactions[i].GeneralFormulas); j++ {
			var generalFormula string = reactions[i].GeneralFormulas[j].ImageName
			var generalFormulaPath string = "resource/" + directoryName + "/" + generalFormula
			if _, err := os.Stat(generalFormulaPath); os.IsNotExist(err) {
				panic("GeneralFormula Not Found, Path: " + generalFormulaPath)
			}
		}

		// Check Mechanism
		for j := 0; j < len(reactions[i].Mechanisms); j++ {
			var mechanism string = reactions[i].Mechanisms[j].ImageName
			var mechanismPath string = "resource/" + directoryName + "/" + mechanism
			if _, err := os.Stat(mechanismPath); os.IsNotExist(err) {
				panic("Mechanism Not Found, Path: " + mechanismPath)
			}
		}

		// Check Example
		for j := 0; j < len(reactions[i].Examples); j++ {
			var example string = reactions[i].Examples[j].ImageName
			var examplePath string = "resource/" + directoryName + "/" + example
			if _, err := os.Stat(examplePath); os.IsNotExist(err) {
				panic("Example Not Found, Path: " + examplePath)
			}
		}

		// Check Supplement
		for j := 0; j < len(reactions[i].Supplements); j++ {
			var supplement string = reactions[i].Supplements[j].ImageName
			var supplementPath string = "resource/" + directoryName + "/" + supplement
			if _, err := os.Stat(supplementPath); os.IsNotExist(err) {
				panic("Supplement Not Found, Path: " + supplementPath)
			}
		}
	}
	fmt.Println("Check Completed!!")
}

func sortReactions(reactions []Reaction) []Reaction{
	sort.SliceStable(reactions, func(i, j int) bool {
		return reactions[i].DirectoryName < reactions[j].DirectoryName
	})
	return reactions
}

func exportReactions(reactions []Reaction) {
	file, _ := json.MarshalIndent(reactions, "", " ")
	_ = ioutil.WriteFile("output/reactions.json", file, 0644)
}
