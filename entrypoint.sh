#!/bin/bash

set -e

if [[ -n $KITCHEN_EC2_SSH_KEY ]]; then
    echo -e $KITCHEN_EC2_SSH_KEY > ~/.ssh/ec2.pem
    chmod 400 ~/.ssh/ec2.pem
fi

if [[ -n $SSH_PRIVATE_KEY ]]; then
    echo -e $SSH_PRIVATE_KEY > ~/.ssh/id_rsa
    chmod 400 ~/.ssh/id_rsa
    ssh-keyscan github.com > ~/.ssh/known_hosts
    cat <<EOF > ~/.ssh/config
Host github.com
  Port 22
  IdentityFile ~/.ssh/id_rsa
EOF
fi

exec "$@"
