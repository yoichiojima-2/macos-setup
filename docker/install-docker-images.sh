#!/bin/bash

install_docker(){
    brew install --cask docker
}

build_ipython_iamge(){
    docker build -t ipython dockerfile/ipython
}

pull_images(){
    while read -r images; do
        docker pull $images
    done < docker-images.txt
}

install_docker
build_ipython_iamge
pull_images