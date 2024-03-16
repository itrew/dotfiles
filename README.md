# dotfiles
A collection of personalized dotfiles and configs I find handy.

## Git
System wide Git configurations can be found in the `git` folder. I have included
a system wide config file that also has conditional includes to separate work
repos from personal repos and sets the `user.email` value accordingly. To setup
this config from scratch, run the `./git/setup_git_config.sh` script to replace
the current `$HOME/.gitconfig` file.

> *`.gitignore` & `.gitattributes`*: Since these are oftentimes project
> specific, I won't include those in the git folder.

### Alias scripts
The configuration includes some custom aliases for common tasks. One is a custom
shell script that prunes local branches that have been squash-merged into the
main branch.
