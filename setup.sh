#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

main() {

  local role="${1:-personal}"
  local git_repo="${2:-https://Mahoney@github.com/Mahoney/machine-setup.git}"

  echo "==========================================="
  echo "Setting up your mac using $git_repo"
  echo "==========================================="

  if ! xcode-select -p 1>/dev/null; then
    xcode-select --install
  fi

  if ! command -v ansible-playbook; then
    if ! command -v pip; then
      curl -fsSL https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
      sudo /usr/bin/python /tmp/get-pip.py
    fi
    sudo pip install ansible
  fi

  local installdir="/tmp/setupmac"

  echo "Cloning/Updating $git_repo into $installdir"
  echo "If asked for a password you may need to use a GitHub access token. You may have stored it in LastPass."
  if [ ! -d "$installdir" ]
  then
      git clone "$git_repo" "$installdir"
  else
      cd "$installdir"
      git pull
  fi
  echo "Done cloning. From now on password requests will be for your local account."

  cd "$installdir"
  ansible-playbook -i ./hosts "$role.yml"

  echo "Setup done"

  exit 0
}

main "$@"
