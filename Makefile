PYTHON_VENV = ~/python-venv/general-purpose
PYTHON_VERSION = 3.12

.PHONY: install-brew
brew-env:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	cat ./brew/brew-casks.txt | xargs brew install
	cat ./brew/brew-formulae.txt | xargs brew install


.PHONY: zsh-env
zsh-env:
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	curl -fsSL -o ~/.zshrc https://github.com/yoichiojima-2/dotfiles/raw/refs/heads/main/.zshrc


.PHONY: docker-env
docker-env: install-brew
	brew install --cask docker
	cat ./docker/docker-images.txt | while read -r line; do docker pull $line; done


.PHONY: node-env
node-env: install-brew
	mkdir -p ~/.nvm
	. ~/.nvm/nvm.sh && nvm install node


.PHONY: vim-env
vim-env: install-brew
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	curl -fsSL -o ~/.config/nvim/init.vim https://raw.githubusercontent.com/yoichiojima-2/dotfiles/refs/heads/main/init.vim


.PHONY: python-env
python-env: brew-env
	pyenv install ${PYTHON_VERSION}
	pyenv global ${PYTHON_VERSION}
	pip install --upgrade pip
	python -m venv ${PYTHON_VENV}
	${PYTHON_VENV}/bin/pip install --upgrade -r ./python/python-requirements.txt


.PHONY: rust-env
rust-env: brew-env
	brew install rustup
	rustup-init


.PHONY: code-env
code-env: brew-env
	cat vscode-extensions.txt | xargs code --install-extension


.PHONY: upgrade-python
upgrade-python:
	${PYTHON_VENV}/bin/pip list | tail -n +3 | awk '{ print $1 }' | xargs pip install --upgrade


.PHONY: upgrade-brew
upgrade-brew:
	brew update
	brew upgrade
	brew upgrade --cask


.PHONY: upgrade
upgrade: upgrade-python upgrade-brew