#!/bin/sh -l

if [ -z "$DESTINATION_BRANCH" ]
then
  DESTINATION_BRANCH=master
fi

sort | env | grep -v API_TOKEN_GITHUB

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
ls -la
git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$GITHUB_USERNAME"
git clone --single-branch --branch $INPUT_DESTINATION_BRANCH "https://$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR"
echo "Checking cloned repo"
ls -la "$CLONE_DIR"

echo "Copying contents to git repo"
cp "$SOURCE_FILE" "$CLONE_DIR/$INPUT_DESTINATION_FOLDER"
cd "$CLONE_DIR"
ls -la

echo "Adding git commit"
git add .
git status
git commit --message "Update from https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"

echo "Pushing git commit"
git push origin $INPUT_DESTINATION_BRANCH