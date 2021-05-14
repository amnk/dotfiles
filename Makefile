default: dotfiles bootstrap

dotfiles:
	for file in $(shell find $(CURDIR) -maxdepth 1 -name ".*" -not -name ".dotfiles" -not -name ".git" -not -name ".gitignore" -not -name ".travis.yml"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;

bootstrap: asdf

asdf:
	bash asdf-bootstrap.sh

.PHONY: dotfiles bootstrap asdf
.NOTPARALLEL: dotfiles bootstrap asdf
