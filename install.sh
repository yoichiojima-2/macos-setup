#!/bin/bash

cd homebrew && bash install-essentials.sh && cd ..
cd python && bash install-python.sh && cd ..
cd node && bash install-node.sh && cd ..
cd nvim && bash install-nvim.sh && cd ..
cd vscode & bash install-vscode.sh && cd .. 
cd docker && bash install-docker-images.sh && cd ..
