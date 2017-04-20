#!/bin/bash -e

BASTION_IP=`terraform output bastion-ip`
WORKER_IP=`terraform output etcd1-ip`
EFS_DNS=`terraform output efs-dns-name`
AWS_EC2_KEY_PATH=.keypair/kz8s-dev.pem

function usage { cat <<EOF
USAGE: $0 key_file bastion_ip [command]
  example: $0 .keypair/k8s-testing.pem 55.11.22.33 "ssh 10.0.0.10 mountstuff"
EOF
  exit 1
}

[ -z "${EFS_DNS}" ] && usage

function finish {
  [ -z ${SSH_AGENT_PID} ] || kill ${SSH_AGENT_PID}
}

eval `ssh-agent -s`
trap finish EXIT

ssh-add ${AWS_EC2_KEY_PATH}

ssh -tA core@${BASTION_IP} \
ssh ${WORKER_IP} << EOF
  mkdir -p efs;
  sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${EFS_DNS}:/ efs;
  cd efs;
  mkdir awesome;
  sudo chmod go+rw .;
  cd ..;
  sudo umount efs;
EOF