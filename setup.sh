#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

main() {

  local role="${1:-personal}"
  local git_repo="${2:-https://Mahoney@github.com/Mahoney/machine-setup.git}"

  echo "==========================================="
  echo "Setting up your mac using $git_repo"
  echo "==========================================="

  if ! command -v ansible-playbook; then
    if ! command -v pip; then
      curl -fsSL https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
      /usr/bin/python --user /tmp/get-pip.py
    fi
    pip install --user ansible
  fi

  local installdir="/tmp/setupmac-$RANDOM"

  mkdir "$installdir"

  echo
  echo "If asked for a password you may need to use an access token. You may have stored it in LastPass."
  git clone "$git_repo" "$installdir"

  cd "$installdir"
  ansible-playbook -i ./hosts "$role.yml"

  rm -Rfv "$installdir"

  echo "Setup done"

  exit 0
}

main "$@"
