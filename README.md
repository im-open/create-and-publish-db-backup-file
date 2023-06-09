# create-and-publish-db-backup-file

This GitHub Action will create a backup file for the specified database and publish it to a nuget repository.  

## Index

- [create-and-publish-db-backup-file](#create-and-publish-db-backup-file)
  - [Index](#index)
  - [Inputs](#inputs)
  - [Example](#example)
  - [Contributing](#contributing)
    - [Incrementing the Version](#incrementing-the-version)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)

## Inputs

| Parameter          | Is Required | Description                                                                                                       |
| ------------------ | ----------- | ----------------------------------------------------------------------------------------------------------------- |
| `db-server-name`   | true        | The name of the database server from which to get the backup.                                                     |
| `db-name`          | true        | The name of the database to back up.                                                                              |
| `backup-path`      | true        | The path to where the backup file should go.                                                                      |
| `backup-name`      | true        | The full name of the backup file, including the file extension.                                                   |
| `version`          | true        | The version number for the backup.                                                                                |
| `nuget-source-url` | true        | The url to the nuget repository where the backup file will be pushed.                                             |
| `nuget-api-key`    | true        | The PAT for the nuget repository where the backup file will be published.                                         |
| `authors`          | false       | A string containing the names of the authors of the backup file. There is no required formatting for this string. |
| `repository-url`   | false       | Use when publishing to GitHub Packages. The url to the repository which should house the published packages.      |

## Example

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
        uses: im-open/create-and-publish-db-backup-file@v1.0.3
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

When creating new PRs please ensure:

1. For major or minor changes, at least one of the commit messages contains the appropriate `+semver:` keywords listed under [Incrementing the Version](#incrementing-the-version).
1. The action code does not contain sensitive information.

When a pull request is created and there are changes to code-specific files and folders, the `auto-update-readme` workflow will run.  The workflow will update the action-examples in the README.md if they have not been updated manually by the PR author. The following files and folders contain action code and will trigger the automatic updates:

- `action.yml`
- `src/**`

There may be some instances where the bot does not have permission to push changes back to the branch though so this step should be done manually for those branches. See [Incrementing the Version](#incrementing-the-version) for more details.

### Incrementing the Version

The `auto-update-readme` and PR merge workflows will use the strategies below to determine what the next version will be.  If the `auto-update-readme` workflow was not able to automatically update the README.md action-examples with the next version, the README.md should be updated manually as part of the PR using that calculated version.

This action uses [git-version-lite] to examine commit messages to determine whether to perform a major, minor or patch increment on merge.  The following table provides the fragment that should be included in a commit message to active different increment strategies.
| Increment Type | Commit Message Fragment                     |
| -------------- | ------------------------------------------- |
| major          | +semver:breaking                            |
| major          | +semver:major                               |
| minor          | +semver:feature                             |
| minor          | +semver:minor                               |
| patch          | *default increment type, no comment needed* |

## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2021, Extend Health, LLC. Code released under the [MIT license](LICENSE).

[git-version-lite]: https://github.com/im-open/git-version-lite
