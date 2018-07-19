# opencb-ansible-docker
Install OpenCB with Docker via Ansible

[![Build Status](https://www.travis-ci.org/JohnGarbutt/opencb-ansible-docker.svg?branch=master)](https://www.travis-ci.org/JohnGarbutt/opencb-ansible-docker)

The new code is under ./compose

  docker-compose up -d

Doing the above should build up the environment, and run the tutuorial.

You can use create-server to make use of an openstack instance, ansible used to bring up docker and the above compose stack.

There is some work here on adding swarm into the ansilbe
https://github.com/JohnGarbutt/data-acc/blob/2c004eaa5ade284d1a70c7d5ebb71427192d4aeb/ansible/master.yml#L24

TODO: more info

## Old Stuff

To run this set of playbooks, please execute:

    ansible-playbook master.yml

## Install notes

You may find this useful to run the above ansible-playbook command:

    virtualenv .venv
    . .venv/bin/activate
    pip install -U pip
    pip install -U ansible docker
    ansible-galaxy install -r requirements.yml

Note it also assumes the current running user can ssh into localhost.

## Using OpenCGA

See the following URL for where opencga is installed:

    http://localhost:8080/opencga-1.2.0

## Monitoring

* Grafana: http://localhost:3000 (user: admin, password: admin)
* Prometheus: http://localhost:9090/consoles/node.html
* Prometheus node exporter: http://localhost:9100/metrics
* cAdvisor: http://localhost:9080
