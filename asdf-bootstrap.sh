#!/bin/bash

if [ -d ${HOME}/.asdf ] ; then 
        source ${HOME}/.asdf/asdf.sh
	asdf plugin add terraform || true
	asdf plugin add gcloud || true
	asdf plugin add helm || true
	asdf plugin add helmfile || true
	asdf plugin add jq || true
	asdf plugin add kubectl || true
	asdf plugin add fzf || true
	asdf plugin add ripgrep || true
	asdf plugin add neovim || true
	asdf plugin add starship || true
	asdf plugin add sops || true
	asdf plugin-add krew https://github.com/nlamirault/asdf-krew.git || true
	asdf install

        kubectl krew install ctx
        kubectl krew install ns
fi
