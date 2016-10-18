package main

import (
	"bufio"
	"bytes"
	"fmt"
	"html/template"
	"log"
	"math"
	"os"
	"path/filepath"
	"strconv"
)

const t = `-- Quartus II generated Memory Initialization File (.mif)

WIDTH=8;
DEPTH={{.Address}};

ADDRESS_RADIX=UNS;
DATA_RADIX=UNS;

CONTENT BEGIN
{{.Data}}
END;
`

func loadContent(filepath string) []int {
	file, err := os.Open(filepath)
	if err != nil {
		log.Fatal("cannot open content file:", filepath)
	}

	var content []int
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lineStr := scanner.Text()
		num, _ := strconv.ParseUint(lineStr, 16, 16)
		content = append(content, int(num))
	}
	defer file.Close()

	return content
}

func main() {
	if len(os.Args) < 3 {
		fmt.Println("Usage: ./convert2mif.exe input.txt output.mif")
		os.Exit(1)
	}

	inFile, _ := filepath.Abs(os.Args[1])
	outFile, _ := filepath.Abs(os.Args[2])
	content := loadContent(inFile)
	address := int(math.Pow(2, math.Ceil(math.Log2(float64(len(content))))))

	var data = ""

	for i, word := range content {
		data += fmt.Sprintf("\t%d : %d;\n", i, word)
	}

	var d = make(map[string]string)
	d["Address"] = strconv.Itoa(address)
	d["Data"] = data

	tmpl, err := template.New("test").Parse(t)
	if err != nil {
		panic(err)
	}

	var doc bytes.Buffer
	if err := tmpl.Execute(&doc, d); err != nil {
		panic(err)
	}
	s := doc.String()

	file, err := os.Create(outFile)
	if err != nil {
		panic(err)
	}

	_, err = file.WriteString(s)
	if err != nil {
		panic(err)
	}
}
