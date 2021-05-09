package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"path/filepath"
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
	Tags            []string         `json:"tags"`
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
	reactions := readReactionsFile("resource/reactions.json")
	checkReactions(reactions)

	// Sort
	reactions = sortReactions(reactions)

	// Clear
	clearOutputDirectory()

	// Export
	fmt.Println("Export Start")
	exportReactions(reactions)
	exportImages(reactions)
	fmt.Println("Export Complete!!")

	// Wait
	waitEnter()
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
	if err := json.Unmarshal(byteValue, &reactions); err != nil {
		fmt.Println(err)
		panic("Fail to Decode reactions.json")
	}
	return reactions
}

// 構成周りで問題ないかチェック
func checkReactions(reactions []Reaction) {
	for i := 0; i < len(reactions); i++ {
		var directoryName string = reactions[i].DirectoryName
		var thmbnailName string = reactions[i].ThmbnailName
		var thmbnailPath string = "resource/images/" + directoryName + "/" + thmbnailName

		// Check Thmbnail
		if _, err := os.Stat(thmbnailPath); os.IsNotExist(err) {
			panic("Thmbnail Not Found, Path: " + thmbnailPath)
		}

		// Check General Formulas
		for j := 0; j < len(reactions[i].GeneralFormulas); j++ {
			var generalFormula string = reactions[i].GeneralFormulas[j].ImageName
			var generalFormulaPath string = "resource/images/" + directoryName + "/" + generalFormula
			if _, err := os.Stat(generalFormulaPath); os.IsNotExist(err) {
				panic("GeneralFormula Not Found, Path: " + generalFormulaPath)
			}
		}

		// Check Mechanism
		for j := 0; j < len(reactions[i].Mechanisms); j++ {
			var mechanism string = reactions[i].Mechanisms[j].ImageName
			var mechanismPath string = "resource/images/" + directoryName + "/" + mechanism
			if _, err := os.Stat(mechanismPath); os.IsNotExist(err) {
				panic("Mechanism Not Found, Path: " + mechanismPath)
			}
		}

		// Check Example
		for j := 0; j < len(reactions[i].Examples); j++ {
			var example string = reactions[i].Examples[j].ImageName
			var examplePath string = "resource/images/" + directoryName + "/" + example
			if _, err := os.Stat(examplePath); os.IsNotExist(err) {
				panic("Example Not Found, Path: " + examplePath)
			}
		}

		// Check Supplement
		for j := 0; j < len(reactions[i].Supplements); j++ {
			var supplement string = reactions[i].Supplements[j].ImageName
			var supplementPath string = "resource/images/" + directoryName + "/" + supplement
			if _, err := os.Stat(supplementPath); os.IsNotExist(err) {
				panic("Supplement Not Found, Path: " + supplementPath)
			}
		}
	}
	fmt.Println("Check Completed!!")
}

// reactionsをディレクトリ名でソート
func sortReactions(reactions []Reaction) []Reaction {
	sort.SliceStable(reactions, func(i, j int) bool {
		return reactions[i].DirectoryName < reactions[j].DirectoryName
	})
	return reactions
}

// outputディレクトリをクリア
func clearOutputDirectory() {
	err := os.RemoveAll("output")
	if err != nil {
		panic(err)
	}
	os.MkdirAll("output", os.ModePerm)
}

// reactions.jsonを出力
func exportReactions(reactions []Reaction) {
	file, _ := json.MarshalIndent(reactions, "", " ")
	_ = ioutil.WriteFile("output/reactions.json", file, 0644)
}

// 画像を出力
func exportImages(reactions []Reaction) {
	for i := 0; i < len(reactions); i++ {
		var directoryName string = reactions[i].DirectoryName
		err := CopyDir("resource/images/"+directoryName, "output/images/"+directoryName)
		if err != nil {
			panic(err)
		}
	}
}

// 文字列入力を待つ
func waitEnter() {
	fmt.Println("Press Enter to Finish")
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
}

// ------------------------------------
// Library
// ------------------------------------
// https://gist.github.com/r0l1/92462b38df26839a3ca324697c8cba04
func CopyFile(src, dst string) (err error) {
	in, err := os.Open(src)
	if err != nil {
		return
	}
	defer in.Close()

	out, err := os.Create(dst)
	if err != nil {
		return
	}
	defer func() {
		if e := out.Close(); e != nil {
			err = e
		}
	}()

	_, err = io.Copy(out, in)
	if err != nil {
		return
	}

	err = out.Sync()
	if err != nil {
		return
	}

	si, err := os.Stat(src)
	if err != nil {
		return
	}
	err = os.Chmod(dst, si.Mode())
	if err != nil {
		return
	}

	return
}

// 画像ファイルを出力
func CopyDir(src string, dst string) (err error) {
	src = filepath.Clean(src)
	dst = filepath.Clean(dst)

	si, err := os.Stat(src)
	if err != nil {
		return err
	}
	if !si.IsDir() {
		return fmt.Errorf("source is not a directory")
	}

	_, err = os.Stat(dst)
	if err != nil && !os.IsNotExist(err) {
		return
	}
	if err == nil {
		return fmt.Errorf("destination already exists")
	}

	err = os.MkdirAll(dst, si.Mode())
	if err != nil {
		return
	}

	entries, err := ioutil.ReadDir(src)
	if err != nil {
		return
	}

	for _, entry := range entries {
		srcPath := filepath.Join(src, entry.Name())
		dstPath := filepath.Join(dst, entry.Name())

		if entry.IsDir() {
			err = CopyDir(srcPath, dstPath)
			if err != nil {
				return
			}
		} else {
			// Skip symlinks.
			if entry.Mode()&os.ModeSymlink != 0 {
				continue
			}

			err = CopyFile(srcPath, dstPath)
			if err != nil {
				return
			}
		}
	}

	return
}
