
Set-Alias -Name vim -value nvim -Scope 'Global'
Set-Alias -Name py -value python -Scope 'Global'

function global:g-s($arguments) {
    git status $arguments
}

function global:g-c($arguments) {
    git checkout $arguments
}

function global:g-f($arguments) {
    git fetch --all --prune $arguments
}

function global:g-r($arguments) {
    git rebase $arguments
}

function global:g-fr($arguments) {
    git fetch --all --prune; git rebase $arguments
}

function global:g-rf($arguments) {
    git fetch --all --prune; git rebase $arguments
}

function global:g-frp($arguments) {
    git stash; git fetch --all --prune; git rebase $arguments
}

function global:g-rfp($arguments) {
    git stash; git fetch --all --prune; git rebase $arguments
}

function global:g-frpp($arguments) {
    git stash; git fetch --all --prune; git rebase ; git stash pop $arguments
}

function global:g-rfpp($arguments) {
    git stash; git fetch --all --prune; git rebase ; git stash pop $arguments
}

function global:g-frp($arguments) {
    git stash; git fetch --all --prune; git rebase $arguments
}

function global:g-rfp($arguments) {
    git stash; git fetch --all --prune; git rebase $arguments
}

function global:g-prf($arguments) {
    git stash; git fetch --all --prune; git rebase $arguments
}

function global:g-prf($arguments) {
    git stash; git fetch --all --prune; git rebase $arguments
}

function global:g-p($arguments) {
    git stash $arguments
}

function global:g-pp($arguments) {
    git stash pop $arguments
}
