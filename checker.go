package main

import (
    "encoding/json"
    "fmt"
    "io/ioutil"
    "os"
    // "strconv"
)

type Reactions struct {
    Reactions []Reaction `json:"reactions"`
}

type Reaction struct {
    DirectoryName   string `json:"directoryName"`
    English   string `json:"english"`
    Japanese   string `json:"japanese"`
    ThmbnailName   string `json:"thmbnailName"`
    GeneralFormulas  []GeneralFormula `json:"generalFormulas"`
    Mechanisms  []Mechanism `json:"mechanisms"`
    Examples  []Example `json:"examples"`
    Supplements  []Supplement `json:"supplements"`
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
    // Open our jsonFile
    jsonFile, err := os.Open("reactions.json")

    // if we os.Open returns an error then handle it
    if err != nil {
        fmt.Println("Fail to Opened reactions.json")
        fmt.Println(err)
        return
    }

    // defer the closing of our jsonFile so that we can parse it later on
    defer jsonFile.Close()

    // read our opened xmlFile as a byte array.
    byteValue, _ := ioutil.ReadAll(jsonFile)

    // we initialize our Reactions array
    var reactions Reactions

    // we unmarshal our byteArray which contains our
    // jsonFile's content into 'reactions' which we defined above
    json.Unmarshal(byteValue, &reactions)

    // we iterate through every user within our reactions array and
    // print out the user Type, their name, and their facebook url
    // as just an example
    for i := 0; i < len(reactions.Reactions); i++ {
        var directoryName string = reactions.Reactions[i].DirectoryName
        var thmbnailName string = reactions.Reactions[i].ThmbnailName
        var thmbnailPath string = "resource/" + directoryName + "/" + thmbnailName

        // Check Thmbnail
        if _, err := os.Stat(thmbnailPath); os.IsNotExist(err) {
            fmt.Println("Thmbnail Not Found, Path: " + thmbnailPath)
            return 
        }

        // Check General Formulas
        for j := 0; j < len(reactions.Reactions[i].GeneralFormulas); j++ {
            var generalFormula string = reactions.Reactions[i].GeneralFormulas[j].ImageName
            var generalFormulaPath string = "resource/" + directoryName + "/" + generalFormula
            if _, err := os.Stat(generalFormulaPath); os.IsNotExist(err) {
                fmt.Println("GeneralFormula Not Found, Path: " + generalFormulaPath)
                return 
            }
        }

        // Check Mechanism
        for j := 0; j < len(reactions.Reactions[i].Mechanisms); j++ {
            var mechanism string = reactions.Reactions[i].Mechanisms[j].ImageName
            var mechanismPath string = "resource/" + directoryName + "/" + mechanism
            if _, err := os.Stat(mechanismPath); os.IsNotExist(err) {
                fmt.Println("Mechanism Not Found, Path: " + mechanismPath)
                return 
            }
        }

        // Check Example
        for j := 0; j < len(reactions.Reactions[i].Examples); j++ {
            var example string = reactions.Reactions[i].Examples[j].ImageName
            var examplePath string = "resource/" + directoryName + "/" + example
            if _, err := os.Stat(examplePath); os.IsNotExist(err) {
                fmt.Println("Example Not Found, Path: " + examplePath)
                return 
            }
        }

        // Check Supplement
        for j := 0; j < len(reactions.Reactions[i].Supplements); j++ {
            var supplement string = reactions.Reactions[i].Supplements[j].ImageName
            var supplementPath string = "resource/" + directoryName + "/" + supplement
            if _, err := os.Stat(supplementPath); os.IsNotExist(err) {
                fmt.Println("Supplement Not Found, Path: " + supplementPath)
                return 
            }
        }
    }
    fmt.Println("Check Completed!!")
}

// english   string `json:"english"`
// japanese   string `json:"japanese"`
// thmbnailName   string `json:"thmbnailName"`