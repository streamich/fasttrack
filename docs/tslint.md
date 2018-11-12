# `tslint` script

Adds TSLint to your project.

- Installs `tslint` and your TSLint config.
- Creates `yarn tslint` script that will lint you `/src` folder.
- Adds `precommit` hook to lint your project on commit.
- Writes `tslint.json` config file.

```shell
ft tslint
```

## Help

```
ft readme [options]

    Creates README file

Options
    --tslint-config        TSLint config to use, defaults to tslint-config-common
    --tslint-config-file   File where to set TSLint config, defaults to tslint.json
    -h, --help             show this output
```
