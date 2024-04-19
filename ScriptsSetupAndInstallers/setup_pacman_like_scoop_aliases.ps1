# remove first if you update
scoop alias rm -S
scoop alias rm -Sy
scoop alias rm -Su
scoop alias rm -Syu
scoop alias rm -Syyu
scoop alias rm -R

# Aliases
scoop alias add -S     'sudo scoop install $args[0] --global'                                 'Install apps'
scoop alias add -Sy    'sudo scoop install $args[0] --global; scoop update $args[0] --global' 'Install apps and updates if it exist'

scoop alias add -Su    'scoop update *; sudo scoop update * --global'                         'Upgrade local and global packages'
scoop alias add -Syu   'scoop update *; sudo scoop update * --global'                         'Upgrade local and global packages'
scoop alias add -Syyu  'scoop update *; sudo scoop update * --global'                         'Upgrade local and global packages'

scoop alias add -R     'sudo scoop uninstall $args[0] --global'                               'Uninstalls an app'

# List outcome
scoop alias list