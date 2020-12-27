# A small and stupid script to install asdf and all plugins I need
#
if ! command -v git &> /dev/null
then
    echo "git could not be found"
    exit 1
fi

git clone https://github.com/asdf-vm/asdf.git ~/.asdf
cd ~/.asdf
git checkout "$(git describe --abbrev=0 --tags)"

. $HOME/.asdf/asdf.sh

asdf plugin add terraform
asdf plugin add gcloud
asdf plugin add helm
asdf plugin add helmfile
asdf plugin add jq
asdf plugin add kubectl
asdf plugin add fzf
asdf plugin add ripgrep
asdf plugin add neovim
asdf plugin add starship

asdf install
