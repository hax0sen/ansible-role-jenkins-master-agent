# Ansible Role: Jenkins Master local agent

[![Build Status](https://img.shields.io/travis/yourusername/ansible-role-jenkins-master/main.svg)](https://travis-ci.org/yourusername/ansible-role-jenkins-master)

## Overview

The Ansible role `ansible-role-jenkins-master` automates the installation and configuration of a Jenkins master within a Docker container. This role sets up a minimal Jenkins master with basic configuration, utilizing a Jenkins Agent on the same VM (acting as a local Jenkins agent).

### Features

- **Plugin Customization**: Easily add your own Jenkins plugins by modifying the list in `files/init/plugins.txt`.

- **Configuration as Code**: Customize Jenkins settings using the Configuration as Code plugin. Explore role variables and YAML files under `templates/jcasc`. Learn more about the plugin and how to tailor it to your requirements at [Configuration as Code Plugin Documentation](https://plugins.jenkins.io/configuration-as-code/).

- **Backup and Restore**: This role includes a backup and restore mechanism through bash scripts and cron jobs. Find details in the `files/backup` directory, specifically in `backup-jenkins.sh` and `restore-jenkins-jobs.sh`.

- **Automatic Plugin Updates**: Plugin updates are managed by a cron job that runs every weekend. Learn more in the `files/update-plugins.sh` file.

- **Caddy reverse proxy**: By default, this role configures a simple HTTPS server using Caddy. For more details, refer to the templates/caddy/Caddyfile file

- **Jenkins Agent Service**: The role also handles a Jenkins agent service on the host for running local agents. Details can be found in the `templates/jenkins-agent` directory, including `jenkins_agent.service` and `jenkins-agent.sh`.
-  If you intend to use multiple Jenkins agents and do not want to run agents on the same system, consider using templates/jcasc/multi-nodes.yml. You can customize this file to meet your specific requirements

## Requirements

Before using this role, ensure the following prerequisites are met:

- **Role Dependencies**: Ensure that the roles listed in requirements.yml are installed. You can use Ansible Galaxy or other methods to manage these dependencies.

- **System Prerequisites**: Make sure Docker and Java are pre-installed on the target system.

For a complete example of how to use this role with role dependencies, you can refer to the sample playbook structure provided in tests/playbook-jenkins-master/playbook.yml:
```yaml
- name: Run playbook for setup Jenkins Master
  gather_facts: true
  hosts: <server>
  become: true
  roles:
  # Ensure docker is installed
    - haxorof.docker_ce
  # Ensure Java is installed
    - ansible-role-openjdk
  # Install and configure Jenkins Master
    - ansible-role-jenkins-master-agent
```
- If Docker and Java are already installed on the host, you can skip the Docker and Java Ansible roles.

## Role Variables
You can find the default variables in the defaults/main.yml file. Key variables are summarized below for your reference. However, it's recommended to follow best practices by customizing these variables using group_vars within your playbook folder.

For illustrative examples and further guidance on customizing variables for various roles, please review the tests/playbook-jenkins-master directory, which includes specific files such as docker.yml, java.yml, jenkins.yml, and main.yml. These files demonstrate how to set variables tailored to different roles.

```yaml
---
################################################################################
# Default variables for setup Jenkins master
################################################################################
# Set system user to run jenkins master service
jenkins_master_system_user: jenkins
# Set this to true if you want to use caddy as reverse proxy(default true)
jenkins_master_caddy: true
# Jenkins master fresh (first setup for install plugins form list) default is false
jenkins_master_fresh: false
# Jenkins master Admin password
jenkins_master_password: ''
# Jenkins master url/ip #example http://192.168.0.266
jenkins_master_url: '' 
# Jenkins master version https://hub.docker.com/r/jenkins/jenkins/tags
jenkins_master_version: 'jenkins:lts-jdk11'
# Jenkins master set system message 
jenkins_master_system_message: "test jenkins master"
# Jenkins master location
jenkins_master_location: /home/{{ jenkins_master_system_user }}
# Jenkins master init location
jenkins_master_location_init: /home/{{ jenkins_master_system_user }}/init
# Jenkins master env location
jenkins_master_location_env: /home/{{ jenkins_master_system_user }}/env
# Jenkins master backup location
jenkins_master_backup_location: /var/jenkins-backup
# Jenkins master sourcecode key phrase
jenkins_master_git__key_phase: ''
# Jenkins agent private key for clone sourcecode
jenkins_agent_master_ssh_private_key: ""
# Jenkins agent public key
jenkins_agent_master_ssh_public_key: ""
# Jenkins agent java version
jenkins_agent_java: []

#If you want to use other VMs as agent. see multi-nodes.yml 
# Jenkins agent to add, some pre requirements is need check README.md
# Example
# jenkins_agents:
#   - host: '<agent-hostname1>'
#     name: '<agent1>'
#     executors: 1
#   - host: '<agent-hostname2>'
#     name: '<agent2>'
#     executors: 2
```
## Example playbooks


```yaml
- name: Run playbook for setup Jenkins Master
  gather_facts: true
  hosts: <server>
  become: true
  roles:
  # Ensure docker is installed
    - haxorof.docker_ce
  # Ensure Java is installed
    - ansible-role-openjdk
  # Install and configure Jenkins Master
    - ansible-role-jenkins-master-agent
```
```yaml
- name: Run playbook for setup Jenkins Master
  gather_facts: true
  hosts: <server>
  become: true
  roles:
  # Install and configure Jenkins Master
    - ansible-role-jenkins-master-agent
```
see `tests/playbooks-jenkins-master` for group_vars and playbook example

## License

This role is licensed under the MIT License. See the LICENSE file for details.



