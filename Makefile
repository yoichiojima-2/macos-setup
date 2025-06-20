PYTHON_VENV = ~/.python-general-purpose
PYTHON_VERSION = 3.13


all: zsh vi code docker node python rust java sql container



.PHONY: zsh
zsh:
	-sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	curl -o ~/.zshrc -fsSL https://raw.githubusercontent.com/yoichiojima-2/dotfiles/main/zshrc


.PHONY: brew
brew: brew/.installed
brew/.installed:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	cat brew-casks.txt | xargs brew install --force
	cat brew-formulae.txt | xargs brew install --force


.PHONY: vi
vi: brew
	brew install nvim
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	curl -fsSL -o ~/.config/nvim/init.vim https://raw.githubusercontent.com/yoichiojima-2/dotfiles/main/init.vim
	nvim +PlugInstall +qall


.PHONY: code
code: brew
	brew install visual-studio-code
	cat code-extensions.txt | xargs -I {} code --install-extension {} --force


.PHONY: docker
docker: brew
	-cat docker-images.txt | while read -r line; do docker pull $$line; done

.PHONY: container
container: brew
	-cat containers.txt | while read -r line; do container images pull $$line; done

.PHONY: node
node: brew
	brew install nvm
	. ~/.nvm/nvm.sh && nvm install node
	npm update
	npm upgrade
	-cat node-modules.txt | while read -r line; do npm install -g $$line; done


.PHONY: python
python: brew
	brew install pyenv
	-pyenv install ${PYTHON_VERSION}
	pyenv global ${PYTHON_VERSION}
	-rm ${PYTHON_VENV}
	python -m venv ${PYTHON_VENV}
	${PYTHON_VENV}/bin/pip install --upgrade pip
	${PYTHON_VENV}/bin/pip install -r python-requirements.txt


.PHONY: rust
rust: brew
	brew install rustup-init
	rustup-init -y


.PHONY: java
java: brew
	brew install openjdk
	sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
	brew install hadoop


.PHONY: sql
sql:
	brew install postgresql@14


.PHONY: upgrade
upgrade:
	brew update
	brew upgrade
	brew upgrade --cask
	yes | gcloud components update
	yes | pip install --upgrade pip


.PHONY: clean
clean:
	-rm ./brew/.installed
	brew cleanup
	docker ps -aq | xargs docker rm
	docker images -q | xargs docker rmi
