export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="half-life"
ZSH_DISABLE_COMPFIX=true
zstyle ':omz:update' mode auto

plugins=(git)
plugins=(zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

zsh_config_files=(
  ~/.zshrc.d/paths.zsh
  ~/.zshrc.d/aliases.zsh
  ~/.zshrc.d/siedos.zsh
)

# Source each file in the array
for config_file in "${zsh_config_files[@]}"; do
  source "$config_file"
done

# Ensure RVM is sourced last
[[ -r "$HOME/.rvm/scripts/completion" ]] && source "$HOME/.rvm/scripts/completion"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

eval "$(starship init zsh)"
