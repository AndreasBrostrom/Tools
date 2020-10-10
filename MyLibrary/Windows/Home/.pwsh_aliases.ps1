
Set-Alias -Name vim -value nvim -Scope 'Global'
Set-Alias -Name py -value python -Scope 'Global'

# Git aliases
function global:g-s()    { git status }
function global:g-c()    { git checkout }
function global:g-b()    { git branch }
function global:g-f()    { git fetch --all --prune }
function global:g-r()    { git rebase }
function global:g-u()    { git rebase origin/master }

function global:g-p()    { git stash }
function global:g-pp()   { git stash pop }

function global:g-pu()   { git push }
function global:g-puf    { git push fork }
function global:g-puff   { git push --set-upstream fork $(git rev-parse --abbrev-ref HEAD) }

function global:g-fr()   { g-f; g-r }
function global:g-rf()   { g-fr }
function global:g-fu()   { g-f; g-u }
function global:g-uf()   { g-fu }

function global:g-frp()  { g-p; g-rf }
function global:g-rfp()  { g-frp }
function global:g-frpp() { g-frp; g-pp }
function global:g-rfpp() { g-frpp }

function global:g-cp()  { g-p; g-c }
function global:g-cpp($arg="master")  { g-p; g-c $arg; g-pp;}
