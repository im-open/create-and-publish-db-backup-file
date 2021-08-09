# create-and-publish-db-backup-file

This GitHub Action will create a backup file for the specified database and publish it to a nuget repository.  
    

## Inputs
| Parameter          | Is Required | Description           |
| ------------------ | ----------- | --------------------- |
| `db-server-name`   | true        | The name of the database server from which to get the backup. |
| `db-name`          | true        | The name of the database to back up. |
| `backup-path`      | true        | The path to where the backup file should go. |
| `backup-name`      | true        | The full name of the backup file, including the file extension. |
| `version`          | true        | The version number for the backup. |
| `nuget-source-url` | true        | The url to the nuget repository where the backup file will be pushed. |
| `nuget-api-key`    | true        | The PAT for the nuget repository where the backup file will be published. |
| `authors`          | false       | A string containing the names of the authors of the backup file. There is no required formatting for this string. |

## Example

```yml
jobs:
  job1:
    runs-on: [self-hosted]
    steps:
      - uses: actions/checkout@v2

      - name: Install Flyway
        uses: im-open/setup-flyway@v1.0.0
        with:
          version: 7.2.0

      - name: Build Database
        uses: im-open/build-database-ci-action@v1.0.1
        with:
          db-server-name: localhost
          db-name: LocalDB
          drop-db-after-build: false

      - name: Create and Publish Backup File
        uses: im-open/create-and-publish-db-backup-file@v1.0.0
        with:
          db-server: localhost
          db-name: LocalDb
          backup-path: "./"
          backup-name: "LocalDb.bak"
          version: "1.0.${{ github.run_number }}"
          nuget-source-url: "https://github.com/my-org/my-repo" # A GitHub packages url
          nuget-api-key: "${{ secrets.MY_GH_PACKAGES_ACCESS_TOKEN }}" # A token that has access to publish packages
          authors: "My-Team"
```


## Code of Conduct

This project has adopted the [im-open's Code of Conduct](https://github.com/im-open/.github/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright &copy; 2021, Extend Health, LLC. Code released under the [MIT license](LICENSE).
