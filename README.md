# create-and-publish-db-backup-file

This GitHub Action will create a backup file for the specified database and publish it to a nuget repository.  

## Index <!-- omit in toc -->

- [create-and-publish-db-backup-file](#create-and-publish-db-backup-file)
  - [Inputs](#inputs)
  - [Usage Examples](#usage-examples)
  - [Contributing](#contributing)
    - [Incrementing the Version](#incrementing-the-version)
    - [Source Code Changes](#source-code-changes)
    - [Updating the README.md](#updating-the-readmemd)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)

## Inputs

| Parameter          | Is Required | Description                                                                                                       |
|--------------------|-------------|-------------------------------------------------------------------------------------------------------------------|
| `db-server-name`   | true        | The name of the database server from which to get the backup.                                                     |
| `db-name`          | true        | The name of the database to back up.                                                                              |
| `backup-path`      | true        | The path to where the backup file should go.                                                                      |
| `backup-name`      | true        | The full name of the backup file, including the file extension.                                                   |
| `version`          | true        | The version number for the backup.                                                                                |
| `nuget-source-url` | true        | The url to the nuget repository where the backup file will be pushed.                                             |
| `nuget-api-key`    | true        | The PAT for the nuget repository where the backup file will be published.                                         |
| `authors`          | false       | A string containing the names of the authors of the backup file. There is no required formatting for this string. |
| `repository-url`   | false       | Use when publishing to GitHub Packages. The url to the repository which should house the published packages.      |

## Usage Examples

```yml
jobs:
  job1:
    runs-on: [self-hosted]
    steps:
      - uses: actions/checkout@v3

      - name: Install Flyway
        uses: im-open/setup-flyway@v1
        with:
          version: 7.2.0

      - name: Build Database
        uses: im-open/build-database-ci-action@v3
        with:
          db-server-name: localhost
          db-name: LocalDB
          drop-db-after-build: false

      - name: Create and Publish Backup File
        uses: im-open/create-and-publish-db-backup-file@v1.1.0
        with:
          db-server: localhost
          db-name: LocalDb
          backup-path: "./"
          backup-name: "LocalDb.bak"
          version: "1.0.${{ github.run_number }}"
          nuget-source-url: "https://github.com/my-org/my-repo" # A GitHub packages url
          nuget-api-key: "${{ secrets.MY_GH_PACKAGES_ACCESS_TOKEN }}" # A token that has access to publish packages
          authors: "My-Team"
          repository-url: "git://github.com/my-org/my-repo.git" # The URL to the repository.
```

## Contributing

When creating PRs, please review the following guidelines:

- [ ] The action code does not contain sensitive information.
- [ ] At least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version] for major and minor increments.
- [ ] The README.md has been updated with the latest version of the action.  See [Updating the README.md] for details.

### Incrementing the Version

This repo uses [git-version-lite] in its workflows to examine commit messages to determine whether to perform a major, minor or patch increment on merge if [source code] changes have been made.  The following table provides the fragment that should be included in a commit message to active different increment strategies.

| Increment Type | Commit Message Fragment                     |
|----------------|---------------------------------------------|
| major          | +semver:breaking                            |
| major          | +semver:major                               |
| minor          | +semver:feature                             |
| minor          | +semver:minor                               |
| patch          | *default increment type, no comment needed* |

### Source Code Changes

The files and directories that are considered source code are listed in the `files-with-code` and `dirs-with-code` arguments in both the [build-and-review-pr] and [increment-version-on-merge] workflows.  

If a PR contains source code changes, the README.md should be updated with the latest action version.  The [build-and-review-pr] workflow will ensure these steps are performed when they are required.  The workflow will provide instructions for completing these steps if the PR Author does not initially complete them.

If a PR consists solely of non-source code changes like changes to the `README.md` or workflows under `./.github/workflows`, version updates do not need to be performed.

### Updating the README.md

If changes are made to the action's [source code], the [usage examples] section of this file should be updated with the next version of the action.  Each instance of this action should be updated.  This helps users know what the latest tag is without having to navigate to the Tags page of the repository.  See [Incrementing the Version] for details on how to determine what the next version will be or consult the first workflow run for the PR which will also calculate the next version.

## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/main/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2023, Extend Health, LLC. Code released under the [MIT license](LICENSE).

<!-- Links -->
[Incrementing the Version]: #incrementing-the-version
[Updating the README.md]: #updating-the-readmemd
[source code]: #source-code-changes
[usage examples]: #usage-examples
[build-and-review-pr]: ./.github/workflows/build-and-review-pr.yml
[increment-version-on-merge]: ./.github/workflows/increment-version-on-merge.yml
[git-version-lite]: https://github.com/im-open/git-version-lite
