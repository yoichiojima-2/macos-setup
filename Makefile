PYTHON_VENV = ~/python-venv/general-purpose
PYTHON_VERSION = 3.13


all: zsh-env brew-env vim-env code-env docker-env node-env python-env rust-env java-env


.PHONY: zsh-env
zsh-env:
	-sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	curl -o ~/.zshrc -fsSL https://raw.githubusercontent.com/yoichiojima-2/dotfiles/main/.zshrc


.PHONY: brew-env
brew-env: brew/.installed
brew/.installed:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	cat brew/casks.txt | xargs brew install
	cat brew/formulae.txt | xargs brew install
	touch brew/.installed


.PHONY: vim-env
vim-env: brew-env
	brew install nvim
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	curl -fsSL -o ~/.config/nvim/init.vim https://raw.githubusercontent.com/yoichiojima-2/dotfiles/main/init.vim


.PHONY: code-env
code-env: brew-env
	brew install visual-studio-code
	cat code/extensions.txt | xargs code --install-extension


.PHONY: docker-env
docker-env: brew-env
	brew install --cask docker
	-cat docker/images.txt | while read -r line; do docker pull $$line; done


.PHONY: node-env
node-env: brew-env
	brew install nvm
	. ~/.nvm/nvm.sh && nvm install node

.PHONY: python-env
python-env: brew-env
	brew install pyenv ruff pytest poetry ipython
	-pyenv install ${PYTHON_VERSION}
	pyenv global ${PYTHON_VERSION}


.PHONY: rust-env
rust-env: brew-env
	brew install rustup-init
	rustup-init -y


.PHONY: java-env
java-env: brew-env
	brew install openjdk
	sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
	brew install hadoop


.PHONY: upgrade-brew
upgrade-brew:
	brew update
	brew upgrade
	brew upgrade --cask


.PHONY: upgrade
upgrade: upgrade-brew
	gcloud components update


.PHONY: clean
clean:
	-rm ./brew/.installed
	brew cleanup
	docker ps -aq | xargs docker rm
	docker images -q | xargs docker rmi
