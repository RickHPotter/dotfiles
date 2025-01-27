export PATH=$PATH:~/nvim/bin/
export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/kitty.app/bin:$PATH

export PATH=/usr/bin/lua:$PATH

export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export PATH=/usr/local/go/bin:$PATH

export PATH=$PATH:/usr/local/bin/exa/bin

export PATH=/usr/bin/android-studio/bin:$PATH
export PATH=/usr/bin/flutter/bin:$PATH

. "$HOME/.cargo/env"

LD_LIBRARY_PATH=/opt/oracle/instantclient_21_12
export LD_LIBRARY_PATH

# NVIM
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
fi

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export VISUAL="nvim"
    export EDITOR="nvim"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
