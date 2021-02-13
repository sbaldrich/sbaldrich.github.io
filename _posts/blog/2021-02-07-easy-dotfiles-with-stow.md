---
layout: post
title: Easy dotfiles with stow
categories: blog
date: 2021-02-13 10:15 +0100
---

Most of the tools I generally use depend on some sort of configuration. Ideally, these configuration files should be versioned
to allow me to easily replicate the configuration in new machines or simply have a quick reference on them by browsing the repository.

So, how to create a repository to store all the configuration files if the location they read from depends on the program that uses them?
One good answer is by using GNU stow:

You can find [way too many](https://www.google.com/search?&q=manage+dotfiles+using+gnu+stow&oq=manage+dotfiles+using+gnu+stow) tutorials on how to use `stow` for managing dotfiles
so I won't go into too much detail. In a nutshell, stow is a [symlink farm manager](https://www.gnu.org/software/stow/) that allows to define packages with files that should be simlinked
from a neatly organized package structure to a target location, which in general is shared with many other packages or unrelated files.

Here's a quick demo of how this would look:

```sh
> cd ~
> mkdir -p dotfiles/{vim/.vim/UltiSnips,doris/.doris,git,zsh}
> cd dotfiles
> touch vim/.vim/.vimrc zsh/.zshrc git/.{gitconfig,gitignore} \
      vim/.vim/UltiSnips/{java,python,scala,kotlin,text}.snippets \
      doris/.doris/config.json
> tree -a
.
├── doris
│   └── .doris
│       └── config.json
├── git
│   ├── .gitconfig
│   └── .gitignore
├── vim
│   └── .vim
│       ├── UltiSnips
│       │   ├── java.snippets
│       │   ├── kotlin.snippets
│       │   ├── python.snippets
│       │   ├── scala.snippets
│       │   └── text.snippets
│       └── .vimrc
└── zsh
    └── .zshrc

7 directories, 10 files
``` 

With a setup like this, a command like `stow doris` will create the `.doris` directory with all its (symlinked) contents in the target location
which by default is the parent directory of the location where you're calling `stow`. This behavior can be controlled with the `--dir` and `--target`
options. Removing such directories is just a matter of using `stow -D` with the name of the package we want to remove.

A good way to see why stow makes sense is by reading the first part of its [manpage](https://linux.die.net/man/8/stow):

> Stow is a tool for managing the installation of multiple software packages in the same run-time directory tree.
 One historical difficulty of this task has been the need to administer, upgrade, install, and remove files in independent packages without confusing them with other files sharing the same filesystem space.  
>
For instance, it is common to install Perl and Emacs in `/usr/local`. When one does so, one winds up (as of Perl 4.036 and Emacs 19.22) with the following files in `/usr/local/man/man1`: `a2p.1`; `ctags.1`; `emacs.1`; `etags.1`; `h2ph.1`; `perl.1`; and `s2p.1`. Now suppose it's time to uninstall Perl. Which man pages get removed? Obviously `perl.1` is one of them, **but it should not be the administrator's responsibility to memorize the ownership of individual files by separate packages**.

So now that you have all your dotfiles neatly arranged in the same place, you can create a repo and be sure that the modifications you do on your config files are both versioned and applied
in all the correct places.

<small> This would be a great place for a catch phrase but I don't have one.</small>

