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
        fmt.Println(err)
        return
    }

    fmt.Println("Successfully Opened reactions.json")
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
        // fmt.Println("User Type: " + reactions.Reactions[i].Type)
        // fmt.Println("User Age: " + strconv.Itoa(reactions.Reactions[i].Age))
        fmt.Println("------------")
        fmt.Println("DirectoryName: " + reactions.Reactions[i].DirectoryName)
        fmt.Println("English: " + reactions.Reactions[i].English)
        fmt.Println("Japanese: " + reactions.Reactions[i].Japanese)
        fmt.Println("ThmbnailName: " + reactions.Reactions[i].ThmbnailName)

        for j := 0; j < len(reactions.Reactions[i].GeneralFormulas); j++ {
            fmt.Println("GeneralFormula: " + reactions.Reactions[i].GeneralFormulas[j].ImageName)
        }

        for j := 0; j < len(reactions.Reactions[i].Mechanisms); j++ {
            fmt.Println("Mechanism: " + reactions.Reactions[i].Mechanisms[j].ImageName)
        }

        for j := 0; j < len(reactions.Reactions[i].Examples); j++ {
            fmt.Println("Example: " + reactions.Reactions[i].Examples[j].ImageName)
        }

        for j := 0; j < len(reactions.Reactions[i].Supplements); j++ {
            fmt.Println("Supplement: " + reactions.Reactions[i].Supplements[j].ImageName)
        }
    }
}

// english   string `json:"english"`
// japanese   string `json:"japanese"`
// thmbnailName   string `json:"thmbnailName"`