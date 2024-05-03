#!/bin/bash

cd homebrew && $SHELL install-essentials.sh && cd ..
cd python && $SHELL install-python.sh && cd ..
cd node && $SHELL install-node.sh && cd ..
cd nvim && $SHELL install-nvim.sh && cd ..
cd vscode & $SHELL install-vscode.sh && cd .. 
cd docker && $SHELL install-docker-images.sh && cd ..
