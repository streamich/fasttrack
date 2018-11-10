# fasttrack

Create TypeScript project with one command.


## Usage

First create your project folder and *cd* into it.

```shell
mkdir my-project
cd my-project
```

Now fast-track your project.

```shell
npx fasttrack-cli ts
```

## Features

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
