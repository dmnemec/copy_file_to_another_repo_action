package main

import (
	"bytes"
	"log"
	logger "log"
	"os"

	"github.com/go-git/go-git"
	"github.com/go-git/go-git/plumbing"
	"github.com/go-git/go-git/plumbing/transport/http"
)

func main() {
	var buf bytes.Buffer
	log := logger.New(&buf, "Move-Files-Logger: ", log.Lshortfile)
	log.Println("Starting action")
	sourceFile := os.Getenv("INPUT_SOURCE_FILE")
	destinationBranch := os.Getenv("INPUT_DESTINATION_BRANCH")
	destinationRepo := os.Getenv("INPUT_DESTINATION_REPO")
	destinationFolder := os.Getenv("INPUT_DESTINATION_FOLDER")
	userEmail := os.Getenv("INPUT_USER_EMAIL")
	userName := os.Getenv("INPUT_USER_EMAIL")

	if len(sourceFile) < 1 {
		log.Panicln("Source file must be provided")
	}

	if len(destinationBranch) < 1 {
		destinationBranch = "master"
	}

	branch := plumbing.NewBranchReferenceName(destinationBranch)

	r, err := git.PlainClone("/tmp/foo", false, &git.CloneOptions{
		URL:           "https://github.com/" + destinationRepo,
		Progress:      os.Stdout,
		SingleBranch:  true,
		ReferenceName: branch,
		Auth: &http.BasicAuth{
			Username: userName,
			Password: os.Getenv("API_TOKEN_GITHUB"),
		},
	})
	check(err)

	ref, err := r.Head()
	check(err)
}

func check(e error) {
	if e != nil {
		log.Panicln(e)
	}
}
