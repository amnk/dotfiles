# dotfiles

# NixOS

After YADM bootstrap is done, link the config:
```bash
sudo cp -r nixos /etc/
```
and rebuild config:
```bash
sudo nixos-rebuild switch
```
