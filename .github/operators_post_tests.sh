#!/bin/bash
set -ex

# Print basic outputs for debug
oc get pods -n openstack

# Create clouds.yaml file to be used in further tests.
mkdir -p ~/.config/openstack
cat > ~/.config/openstack/clouds.yaml << EOF
$(oc get cm openstack-config -n openstack -o json | jq -r '.data["clouds.yaml"]')
EOF
export OS_CLOUD=default
export OS_PASSWORD=12345678

# Post tests for mariadb-operator
# Check to confirm they we can login into mariadb container and show databases.
oc exec -it  pod/mariadb-openstack -- mysql -uroot -p12345678 -e "show databases;"

# Post tests for keystone-operator
# Check to confirm you can issue a token.
openstack token issue
