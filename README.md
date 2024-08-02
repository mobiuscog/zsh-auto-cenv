# zsh-auto-cenv
Automatically activate conda environment when entering the project folder

# usage
If an `environment.yml` (`environment.yaml`) file is present within a directory, the `name` will be used as
the environment name to activate. It will silently fail if an environment with that name does not exist.