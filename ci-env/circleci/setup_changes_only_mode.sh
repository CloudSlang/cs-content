#!/bin/bash

# parameters to the script:
#   - COREOS_MACHINE_NAMES - string with machines names separated by space
#   - DO_API_TOKEN - DigitalOcean personal access token
#   - DO_DROPLET_SSH_PUBLIC_KEY_ID - ID of the SSH public key in DigitalOcean
#   - DO_REGION - DigitalOcean region where the droplets should be created
#   - CLOUD_CONFIG_FILE - path to the cloud-config file
#   - DROPLETS_FILE - droplets info is stored in this file (e.g. IDs)

git remote -v
git fetch origin master
git branch -a
git diff --name-only origin/master -- > difflist.txt
cat difflist.txt
grep '.sl$' difflist.txt > changed_items.txt
sed -i -e 's/\//\./g' changed_items.txt
sed -i -e 's/test\.//g' changed_items.txt
sed -i -e 's/content\.//g' changed_items.txt
sed -i -e 's/\.sl//g' changed_items.txt
cat changed_items.txt