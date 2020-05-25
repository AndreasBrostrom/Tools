@echo off

:: Programs
DOSKEY vim=nvim $*
DOSKEY py=python $*

:: Git
DOSKEY g-s=git status $*
DOSKEY g-c=git checkout $*

DOSKEY g-f=git fetch --all --prune $*
DOSKEY g-r=git rebase $*

DOSKEY g-fr=git fetch --all --prune $T git rebase $*
DOSKEY g-rf=git fetch --all --prune $T git rebase $*

DOSKEY g-frp=git stash $T git fetch --all --prune $T git rebase $*
DOSKEY g-rfp=git stash $T git fetch --all --prune $T git rebase $*

DOSKEY g-frpp=git stash $T git fetch --all --prune $T git rebase $* $T git stash pop
DOSKEY g-rfpp=git stash $T git fetch --all --prune $T git rebase $* $T git stash pop

DOSKEY g-frp=git stash $T git fetch --all --prune $T git rebase $*
DOSKEY g-rfp=git stash $T git fetch --all --prune $T git rebase $*
DOSKEY g-prf=git stash $T git fetch --all --prune $T git rebase $*
DOSKEY g-prf=git stash $T git fetch --all --prune $T git rebase $*

DOSKEY g-p=git stash $*
DOSKEY g-pp=git stash pop $*
