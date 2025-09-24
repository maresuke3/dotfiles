. "$HOME/.cargo/env"


# Go path settings
export GOROOT=$(mise where go)
export PATH=$GOROOT/bin:$PATH
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
