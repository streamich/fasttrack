# *Fast Track*

FastTrack is not a single boilerplate, but a collection of scripts that
allow you to create your custom project boilerplate.

Install:

```shell
bash <(curl -s https://raw.githubusercontent.com/streamich/fasttrack/master/install.sh)
```

Create a TypeScript project:

```shell
mkdir my-project && cd my-project
ft project-ts
```


## Usage

```shell
ft <script> [options]
```


## Reference

- [__Installation__](./docs/installation.md)
- [__Usage__](./docs/usage.md)


## Scripts

To see help run:

```shell
ft <script> --help
```

- [`build-ts`](./docs/build-ts.md) &mdash; Sets up TypeScript build and clean scripts.
- [`build-webpack`](./docs/build-webpack.md) &mdash; Sets up TypeScript build with Webpack.
- [`ci-circleci`](./docs/ci-circleci.md) &mdash; Adds [CircleCI](https://circleci.com/) with automatic releases using `yarn release` command on merge to `master`.
- [`ci-travis`](./docs/ci-travis.md) &mdash; Adds [Travis CI](https://travis-ci.com/) with automatic releases using `yarn release` command on merge to `master`.
- [`codegen-ts`](./docs/codegen-ts.md) &mdash; Creates sample `/src` folder with TypeScript code.
- [`commitizen`](./docs/commitizen.md) &mdash; Sets [`git-cz`](https://github.com/streamich/git-cz) Commitizen config.
- [`commitlint`](./docs/commitlint.md) &mdash; Adds [`commitlint`](https://marionebl.github.io/commitlint/#/) to your project.
- [`git`](./docs/git.md) &mdash; Inits [Git](https://git-scm.com/) and creates first commit.
- [`gitignore`](./docs/gitignore.md) &mdash; Adds `.gitignore` to your project.
- [`jest`](./docs/jest.md) &mdash; Adds [Jest](https://jestjs.io/) to your project.
- [`license`](./docs/license.md) &mdash; Adds license to your projects.
- [`package`](./docs/package.md) &mdash; Creates `package.json`.
- [`prettier`](./docs/prettier.md) &mdash; Adds Prettier to your project.
- [`react`](./docs/react.md) &mdash; Installs [React](https://reactjs.org/).
- [`readme`](./docs/readme-script.md) &mdash; Adds a README file.
- [`semantic-release`](./docs/semantic-release.md) &mdash; Adds semantic [`semantic-release`](https://semantic-release.gitbook.io/semantic-release/) using `yarn release` command to your project.
- [`tslint`](./docs/tslint.md) &mdash; Adds [`tslint`](https://palantir.github.io/tslint/) to your project.
- [`typescript`](./docs/typescript.md) &mdash; Installs TypeScript in your project.


## Projects

Projects are simply scripts that run a collection of other scripts. You can specify all CLI params
for projects that you would use for scripts.

- [`project-ts`](./docs/project-ts.md) &mdash; Creates a TypeScript project.
- [`project-react-ts`](./docs/project-react-ts.md) &mdash; Creates a TypeScript project with React.


## License

[Unlicense](LICENSE) &mdash; public domain.
