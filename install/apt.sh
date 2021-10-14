#!/bin/sh
if is-executable apt; then
  echo "**************************************************"
  echo "Configuring services with apt"
  echo "**************************************************"
else
  echo "**************************************************"
  echo "Skipping apt packages installation: Not linux"
  echo "**************************************************"
  return
fi

sudo apt install kubernetes
