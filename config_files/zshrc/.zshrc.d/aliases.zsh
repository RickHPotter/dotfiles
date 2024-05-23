alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gcg="git config --edit --global"
alias gcl="git config --edit --local"

alias "cc=xclip -selection clipboard"
alias "cv=xclip -o"
alias "nvim.custom=cd ~/.config/nvim && nvim init.lua"
alias "zshrc=nvim ~/.zshrc"

alias t_fin="tmux attach -t fin || tmux new -s fin"
