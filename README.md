# GitHub Action: Run markuplint with reviewdog

This action runs [markuplint](https://github.com/markuplint/markuplint) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve code review experience.

## Inputs

### `github_token`

**Required**. Default is `${{ github.token }}`.

### `level`

Optional. Report level for reviewdog \[`info`,`warning`,`error`\].
It's same as `-level` flag of reviewdog.

### `reporter`

Reporter of reviewdog command \[`github-pr-check`,`github-check`,`github-pr-review`\].
Default is `github-pr-review`.
It's same as `-reporter` flag of reviewdog.

`github-pr-review` can use Markdown and add a link to rule page in reviewdog reports.

### `filter_mode`

Optional. Filtering mode for the reviewdog command \[`added`,`diff_context`,`file`,`nofilter`\].
Default is added.

### `fail_on_error`

Optional. Exit code for reviewdog when errors are found \[`true`,`false`\]
Default is `false`.

### `reviewdog_flags`

Optional. Additional reviewdog flags

### `markuplint_targets`

Optional. File paths or glob patterns for linting by markuplint. Default: `**/*.html`.

### `markuplint_flags`

Optional. Flags and args of markuplint command. Default: '.'

### `workdir`

Optional. The directory from which to look for and run markuplint. Default '.'

## Example usage

You also need to install [markuplint](https://github.com/markuplint/markuplint).

```shell
# Example
$ npm install markuplint -D
```

You can create [markuplint
config](https://markuplint.dev/docs/configuration)
and this action uses that config too.

### [.github/workflows/reviewdog.yml](.github/workflows/reviewdog.yml)

```yaml
name: markuplint
on: [pull_request]
jobs:
  markuplint:
    name: runner / markuplint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: reviewdog/action-markuplint@v1
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          reporter: github-pr-review
```
