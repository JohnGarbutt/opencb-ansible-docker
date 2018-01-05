# opencb-ansible-docker
Install OpenCB with Docker via Ansible

[![Build Status](https://www.travis-ci.org/JohnGarbutt/opencb-ansible-docker.svg?branch=master)](https://www.travis-ci.org/JohnGarbutt/opencb-ansible-docker)

To run this set of playbooks, please execute:

    ansible-playbook master.yml

## Install notes

You may find this useful to run the above ansible-playbook command:

    virtualenv .venv
    . .venv/bin/activate
    pip install -U pip
    pip install -U ansible docker

Note it also assumes the current running user can ssh into localhost.

## Using OpenCGA

See the following URL for where opencga is installed:

    http://localhost:8080/opencga/

## Monitoring

* Grafana: http://localhost:3000 (user: admin, password: admin)
* Prometheus: http://localhost:9090
* Prometheus node exporter: http://localhost:9100
* cAdvisor: http://localhost:9080
