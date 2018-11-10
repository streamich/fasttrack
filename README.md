# fasttrack

Install:

```shell
bash <(curl -s https://raw.githubusercontent.com/streamich/fasttrack/master/install.sh)
```

Create a TypeScript project:

```shell
mkdir my-project && cd my-project
fasttrack project-ts
```


## Usage

```shell
fasttrack <script> [options]
```


## Reference

- [__Installation__](./docs/installation.md)
- [__Usage__](./docs/usage.md)


## Scripts

To see help run:

```shell
fasttrack <script> --help
```

- [`package`](./docs/package.md) &mdash; Creates `package.json`.
- [`readme`](./docs/readme-script.md) &mdash; Adds a README file.
- `license` &mdash; Adds license to your projects.
- `typescript` &mdash; Installs TypeScript in your project.
- [`prettier`](./docs/prettier.md) &mdash; Adds Prettier to your project.
- `tslint` &mdash; Adds [`tslint`](https://palantir.github.io/tslint/) to your project.
- `commitlint` &mdash; Adds [`commitlint`](https://marionebl.github.io/commitlint/#/) to your project.
- `commitizen` &mdash; Sets [`git-cz`](https://github.com/streamich/git-cz) Commitizen config.
- `gitignore` &mdash; Adds `.gitignore` to your project.
- `codegen-ts` &mdash; Creates sample `/src` folder with TypeScript code.
- `build-ts` &mdash; Sets up TypeScript `yarn build` script to write output to `/lib` folder.
- `ci-circleci` &mdash; Adds [CircleCI](https://circleci.com/) with automatic releases using `yarn release` command on merge to `master`.
- `semantic-release` &mdash; Adds semantic [`semantic-release`](https://semantic-release.gitbook.io/semantic-release/) using `yarn release` command to your project.
- `git` &mdash; Inits [Git](https://git-scm.com/) and creates first commit.
- `jest` &mdash; Adds [Jest](https://jestjs.io/) to your project.


## Projects

Projects are simply scripts that run a collection of other scripts. You can specify all CLI params
for projects that you would use for scripts.

- [`project-ts`](./docs/project-ts.md) &mdash; Creates a TypeScript project.


## License

[Unlicense](LICENSE) &mdash; public domain.
