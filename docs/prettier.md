# `prettier` script

Add Prettier to your project.

- Installs `prettier` and `pretty-quick`
- Creates `prettier.config.js` config file.
- Adds `yarn prettier` script to format all your `/src` folder.
- Adds `yran prettier:diff` script to verify all files in `/src` are correctly formatted.
- Runs `yarn prettier:diff` on `prepush` hook.
- Runs `pretty-quick` on `precommit` hook.

```shell
ft prettier
```

Customize Prettier.

```shell
ft prettier \
  --prettier-config prettier.js \
  --prettier-semi false \
  --prettier-bracket-spacing true
```

## Help

```
ft prettier [options]

 - Installs Prettier and pretty-quick
 - Adds scripts to package.json

Options
    --prettier-config                 Config file, defaults to prettier.config.js
    --prettier-arrow-parens           arrowParams setting, defaults to 'always'
    --prettier-print-width            printWidth setting, defaults to 120
    --prettier-trailing-comma         trailingComma setting, defaults to 'all'
    --prettier-use-tabs               useTabs setting, defaults to false
    --prettier-semi                   semi setting, defaults to true
    --prettier-single-quote           singleQuote setting, defaults to true
    --prettier-bracket-spacing        bracketSpacing setting, defaults to false
    --prettier-jsx-bracket-same-line  jsxBracketSameLine setting, defaults to false
    -h, --help                        show this output
```
