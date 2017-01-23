#!/bin/bash

set -e

if [[ -n $EC2_SSH_KEY ]]; then
    echo -e $EC2_SSH_KEY > ~/.ssh/ec2.pem
    chmod 400 ~/.ssh/ec2.pem
fi

if [[ -n $GITHUB_SSH_KEY ]]; then
    echo -e $GITHUB_SSH_KEY > ~/.ssh/id_rsa
    chmod 400 ~/.ssh/id_rsa
    ssh-keyscan github.com > ~/.ssh/known_hosts
    cat <<EOF > ~/.ssh/config
Host github.com
  Port 22
  IdentityFile ~/.ssh/id_rsa
EOF
fi

exec "$@"
