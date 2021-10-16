#!/bin/sh
if is-debian && is-executable apt; then
  echo "**************************************************"
  echo "Configuring services with apt"
  echo "**************************************************"
else
  echo "**************************************************"
  echo "Skipping apt packages installation: Not linux"
  echo "**************************************************"
  return
fi

sudo apt install jq
sudo apt install jsonlint
sudo apt install kubernetes
sudo apt install tree
sudo apt install yamllint
