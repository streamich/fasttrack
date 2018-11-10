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
fastrack <script> [options]
```


## Reference

- [__Installation__](./docs/installation.md)
- [__Usage__](./docs/usage.md)


## `<scripts>`

- Adds `package.json`
- Adds README
- Adds license
- Adds [Husky hooks](https://github.com/typicode/husky)
- Adds [TypeScript](https://www.typescriptlang.org/) and `tsconfig.json`
- Adds [Prettier](https://github.com/prettier/prettier)
- Adds [`tslint`](https://palantir.github.io/tslint/)
- Adds [`commitlint`](https://marionebl.github.io/commitlint/#/) and [`git-cz`](https://github.com/streamich/git-cz) Commitizen config
- Adds `.gitignore`
- Creates a `/src` folder
- Sets up TypeScript `yarn build` script to `/lib` folder
- Adds [CircleCI](https://circleci.com/) with automatic releases using [`semantic-release`](https://semantic-release.gitbook.io/semantic-release/) on merge to `master`
- Adds [Git](https://git-scm.com/) and creates first commit
- And more.
