# `github` script

Creates GitHub repo and pushes first commit.
You need to set your GitHub token as `GITHUB_TOKEN_FASTTRACK` env var or in `--github-token` param.

- Creates GitHub repo.
- Adds `origin` remote to your repo.
- Pushes everything to `master`.

```shell
ft github
```


## Help

```
fasttrack github [options]

    Crete GitHub repo and push.
    You need to set GITHUB_TOKEN_FASTTRACK env var.
    Or use --github-token param.

Options
    --project          repo name, defaults to folder name
    --github-token     GitHub access token
    -h, --help         show this output
```
