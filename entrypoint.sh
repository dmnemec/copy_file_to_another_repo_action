#!/bin/sh

if [ -z "$DESTINATION_BRANCH" ]
then
  DESTINATION_BRANCH=master
fi

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
git config --global user.email "$USER_EMAIL"
git config --global user.name "$GITHUB_USERNAME"
git clone --single-branch --branch $DESTINATION_BRANCH "https://$API_TOKEN_GITHUB@github.com/$GITHUB_REPO.git" "$CLONE_DIR"
ls -la "$CLONE_DIR"

echo "Copying contents to to git repo"
ls -la
cp "$SOURCE_FILE" "$CLONE_DIR/$DESTINATION_FOLDER"
cd "$CLONE_DIR"
ls -la

echo "Adding git commit"
git add .
git status
git commit --message "Update from https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"

echo "Pushing git commit"
git push origin $DESTINATION_BRANCH