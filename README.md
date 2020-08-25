# copy_file_to_another_repo_action
This GitHub Action copies a file from the current repository to a location in another repository

# Example Workflow
    name: Push File

    on: pull_request

    jobs:
      copy-file:
        runs-on: ubuntu-latest
        steps:
        - name: Checkout
            uses: actions/checkout@v2
        - name: Pushes test file
            uses: dmnemec/copy_file_to_another_repo_action@master
            env:
            API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
            with:
            source_file: 'test.md'
            destination_repo: 'dmnemec/release-test'
            destination_folder: ''
            user_email: devin.nemec@gmail.com