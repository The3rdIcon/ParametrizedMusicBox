package main

import (
	"html/template"
	"io/ioutil"
	"os"
)

type config struct {
	ShouldPrint                    int
	ShouldGenerateCylinder         int
	ShouldGenerateTransmissionGear int
	ShouldGenerateCrankGear        int
	ShouldGenerateCrank            int
	ShouldGeneratePulley           int
	ShouldGenerateCase             int
	SongName                       string
}

func main() {
	f, _ := ioutil.ReadFile("./boxtemplate.scad")
	t := template.New("box")
	t, _ = t.Parse(string(f))
	c := config{
		SongName: "Hello",
	}
	t.Execute(os.Stdout, c)
}
