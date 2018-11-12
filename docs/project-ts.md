# TypeScript project

Runs scripts: `package`, `readme`, `license`,
`typescript`, `prettier`, `tslint`, `commitlint`, `commitizen`, `gitignore`, `codegen-ts`,
`build-ts`, `ci-circleci`, `semantic-release`, `jest`, `git`, `github`.

Install default TypeScript project.

```shell
ft project-ts
```

Install TypeScript project with MIT license and 80 line width.

```shell
ft project-ts \
  --license MIT \
  --prettier-print-width 80
```

Use any setting from child scripts.

```shell
ft project-ts \
  --username streamich \
  --readme-file README \
  --project my-project \
  --readme-description "New project that will save the world." \
  --license MIT \
  --prettier-config "prettier.js" \
  --prettier-print-width 100 \
  --prettier-trailing-comma es5 \
  --prettier-use-tabs false \
  --prettier-semi false \
  --prettier-single-quote false \
  --prettier-bracket-spacing true \
  --prettier-jsx-bracket-same-line true \
  --tslint-config-file "tslint-config.json" \
  --commitlint-config-file "commitlint.js" \
  --commitizen-path "mol-conventional-changelog" \
  --gitignore-type Node \
  --ci-circleci-image node:10.10 \
  --jest-config-file "jest.js"
```
