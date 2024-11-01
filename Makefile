PYTHON_VENV = ~/python-venv/general-purpose
PYTHON_VERSION = 3.12


all: brew-env zsh-env docker-env node-env vim-env python-env rust-env code-env


.PHONY: .brew/.installed
brew-env: .brew/.installed
brew/.installed:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	cat ./brew/casks.txt | xargs brew install
	cat ./brew/formulae.txt | xargs brew install
	touch ./brew/.installed


.PHONY: zsh-env
zsh-env:
	-sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	curl -fsSL -o ~/.zshrc https://github.com/yoichiojima-2/dotfiles/raw/refs/heads/main/.zshrc


.PHONY: docker-env
docker-env: brew-env
	brew install --cask docker
	cat ./docker/images.txt | while read -r line; do docker pull $$line; done


.PHONY: node-env
node-env: brew-env
	. ~/.nvm/nvm.sh && nvm install node


.PHONY: vim-env
vim-env: brew-env
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	curl -fsSL -o ~/.config/nvim/init.vim https://raw.githubusercontent.com/yoichiojima-2/dotfiles/refs/heads/main/init.vim


.PHONY: python-env
python-env: brew-env
	pyenv install ${PYTHON_VERSION}
	pyenv global ${PYTHON_VERSION}
	python -m venv ${PYTHON_VENV}
	${PYTHON_VENV}/bin/pip install --upgrade pip
	${PYTHON_VENV}/bin/pip install --upgrade -r ./python/requirements.txt


.PHONY: rust-env
rust-env: brew-env
	brew install rustup
	rustup-init


.PHONY: code-env
code-env: brew-env
	cat ./code/extensions.txt | xargs code --install-extension


.PHONY: upgrade-python
upgrade-python:
	${PYTHON_VENV}/bin/pip list | tail -n +3 | awk '{ print $$1 }' | xargs ${PYTHON_VENV}/bin/pip install --upgrade


.PHONY: upgrade-brew
upgrade-brew:
	brew update
	brew upgrade
	brew upgrade --cask


.PHONY: upgrade
upgrade: upgrade-python upgrade-brew