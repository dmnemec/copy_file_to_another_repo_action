# copy_file_to_another_repo_action
This GitHub Action copies a file from the current repository to a location in another repository

# Example Workflow
    name: Push File

    on: push

    jobs:
      copy-file:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout
          uses: actions/checkout@v2

        - name: Pushes test file
          uses: dmnemec/copy_file_to_another_repo_action@v1.0.4
          env:
            API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
          with:
            source_file: 'test2.md'
            destination_repo: 'dmnemec/release-test'
            destination_folder: 'test-dir'
            user_email: 'devin.nemec@gmail.com'
            user_name: 'dmnemec'

# Variables
* source_file: The file or directory to be moved. Uses the same syntax as the `cp` command. Incude the path for any files not in the repositories root directory.
* destination_repo: The repository to place the file or directory in.
* destination_folder: [optional] The folder in the destination repository to place the file in, if not the root directory.
* user_email: The GitHub user email associated with the API token secret.
* user_name: The GitHub username associated with the API token secret.
* destination_branch: [optional] The branch of the source repo to update, if not master.

# Behavior Notes
The action will create any destination paths if they don't exist. It will also overwrite existing files if they already exist in the locations being copied to. It will not delete the entire destination repository.
