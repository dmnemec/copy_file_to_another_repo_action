#!/bin/sh

set -e
set -x

if [ -z "$INPUT_SOURCE_FILE" ]
then
  echo "Source file must be defined"
  return 1
fi

if [ -z "$INPUT_GIT_SERVER" ]
then
  INPUT_GIT_SERVER="github.com"
fi

if [ -z "$INPUT_DESTINATION_BRANCH" ]
then
  INPUT_DESTINATION_BRANCH=main
fi
OUTPUT_BRANCH="$INPUT_DESTINATION_BRANCH"

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$INPUT_USER_NAME"
git clone --single-branch --branch $INPUT_DESTINATION_BRANCH "https://x-access-token:$API_TOKEN_GITHUB@$INPUT_GIT_SERVER/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR"

if [ ! -z "$INPUT_RENAME" ]
then
  echo "Setting new filename: ${INPUT_RENAME}"
  DEST_COPY="$CLONE_DIR/$INPUT_DESTINATION_FOLDER/$INPUT_RENAME"
else
  DEST_COPY="$CLONE_DIR/$INPUT_DESTINATION_FOLDER"
fi

echo "Copying contents to git repo"
mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER
if [ -z "$INPUT_USE_RSYNC" ]
then
  cp -R "$INPUT_SOURCE_FILE" "$DEST_COPY"
else
  echo "rsync mode detected"
  rsync -avrh "$INPUT_SOURCE_FILE" "$DEST_COPY"
fi

cd "$CLONE_DIR"

if [ ! -z "$INPUT_DESTINATION_BRANCH_CREATE" ]
then
  echo "Creating new branch: ${INPUT_DESTINATION_BRANCH_CREATE}"
  git checkout -b "$INPUT_DESTINATION_BRANCH_CREATE"
  OUTPUT_BRANCH="$INPUT_DESTINATION_BRANCH_CREATE"
fi

if [ -z "$INPUT_COMMIT_MESSAGE" ]
then
  INPUT_COMMIT_MESSAGE="Update from https://$INPUT_GIT_SERVER/${GITHUB_REPOSITORY}/commit/${GITHUB_SHA}"
fi

echo "Adding git commit"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "$INPUT_COMMIT_MESSAGE"
  echo "Pushing git commit"
  if git push -u origin HEAD:$OUTPUT_BRANCH; then
    echo "Git push succeeded"
  elif [ $((INPUT_RETRY_ATTEMPTS)) -gt 0 ]; then
    echo "Retrying git push"
    for (( index=0; index<$((INPUT_RETRY_ATTEMPTS)); index++ )); do
      sleep $((1 + $RANDOM % 5))s
      git fetch
      git rebase
      if git push; then
        exit 0;
      fi
    done
    echo "Can not push changes to $OUTPUT_BRANCH after retrying $INPUT_RETRY_ATTEMPTS attempts"
  fi
else
  echo "No changes detected"
fi
