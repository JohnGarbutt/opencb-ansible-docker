#!/bin/bash

virtualenv .venv-create
source .venv-create/bin/activate
pip install -U pip
pip install -U setuptools
pip install python-openstackclient
pip install ansible

set -eux

NAME="opencga-test"

export OS_CLOUD=${OS_CLOUD:-"cam"}
if [ "$OS_CLOUD" == "cam" ]
then
	FLAVOR=${FLAVOR:-"C1.vss.medium"}
	IMAGE_NAME=${IMAGE_NAME:-"CentOS-7-x86_64-GenericCloud"}
	USER="centos"
	KEYPAIR_NAME=${KEYPAIR_NAME:-usual}
	NETWORK_NAME=${NETWORK_NAME:-opencb}
	EXTERNAL_NETWORK_NAME=${EXTERNAL_NETWORK_NAME:-CUDN-Internet}
fi
if [ "$OS_CLOUD" == "hphi" ]
then
	FLAVOR=${FLAVOR:-"4x16"}
	IMAGE_NAME=${IMAGE_NAME:-"CentOS7"}
	USER="centos"
	KEYPAIR_NAME=${KEYPAIR_NAME:-mine}
	NETWORK_NAME=${NETWORK_NAME:-test}
	EXTERNAL_NETWORK_NAME=${EXTERNAL_NETWORK_NAME:-dev-vlan}
fi
if [ "$OS_CLOUD" == "alaska" ]
then
	FLAVOR=${FLAVOR:-"compute-A"}
	IMAGE_NAME=${IMAGE_NAME:-"CentOS7"}
	USER="centos"
	KEYPAIR_NAME=${KEYPAIR_NAME:-usual}
	NETWORK_NAME=${NETWORK_NAME:-p3-internal}
	EXTERNAL_NETWORK_NAME=${EXTERNAL_NETWORK_NAME:-ilab}
fi

if ! openstack server show $NAME >/dev/null 2>&1; then
	openstack server create \
		--image $IMAGE_NAME \
		--flavor $FLAVOR \
		--key-name $KEYPAIR_NAME \
		--network $NETWORK_NAME \
		--wait \
		$NAME


	uuid=$(openstack server show $NAME --format value -c id)
	floating_ip=$(openstack floating ip create $EXTERNAL_NETWORK_NAME -c floating_ip_address --format value)
	openstack server add floating ip $uuid $floating_ip

	# wait for server to startup
	while ! ping -c 1 -n -w 1 $floating_ip &> /dev/null
	do
		echo "."
	done
fi

#ip=$(openstack server show $NAME --format value -c addresses | cut -c 6-)
uuid=$(openstack server show $NAME --format value -c id)
#ssh $USER@$ip

./create-inventory-from-server.py $uuid > ./ansible/inventory

cd ansible

ansible-galaxy install -r requirements.yml
ansible-playbook -i inventory main.yml

cd ..

deactivate
