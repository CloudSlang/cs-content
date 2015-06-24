#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Deletes all Docker images and containers from s Docker Swarm cluster.
#
# Inputs:
#   - swarm_manager_ip - IP address of the machine with the Swarm manager container
#   - swarm_manager_port - port used by the Swarm manager container
#   - excluded_images - optional - containers based on these images will not be deleted
#                                - used for filtering out containers used by Swarm e.g. agent containers
#                     - Default: swarm:latest
#   - host - Docker machine host
#   - port - optional - SSH port
#   - username - Docker machine username
#   - password - optional - Docker machine password
#   - private_key_file - optional - path to private key file
#   - character_set - optional - character encoding used for input stream encoding from target machine - Valid: SJIS, EUC-JP, UTF-8
#   - pty - optional - whether to use PTY - Valid: true, false
#   - timeout - optional - time in milliseconds to wait for the command to complete
#   - close_session - optional - if false SSH session will be cached for future calls during the life of the flow, if true the SSH session used will be closed; Valid: true, false
#   - agent_forwarding - optional - whether to forward the user authentication agent
# Outputs:
#   - amount_of_images_deleted - how many images (not including dangling) were deleted
#   - amount_of_dangling_images_deleted - how many dangling images were deleted
#   - total_amount_of_images_deleted - how many images (including dangling) were deleted
# Results:
#   - SUCCESS - Swarm cluster cleared successfully
#   - FAILURE - otherwise
####################################################

namespace: io.cloudslang.docker.swarm

imports:
  containers: io.cloudslang.docker.containers
  images: io.cloudslang.docker.images

flow:
  name: clear_swarm_cluster
  inputs:
    - swarm_manager_ip
    - swarm_manager_port
    - excluded_images: "'swarm:latest'"
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - character_set:
        required: false
    - pty:
        required: false
    - timeout:
        required: false
    - close_session:
        required: false
    - agent_forwarding:
        required: false
    - docker_options:
        default: >
          '-H tcp://' + swarm_manager_ip + ':' + swarm_manager_port
        overridable: false

  workflow:
    - get_containers_in_cluster:
        do:
          containers.get_filtered_containers:
            - docker_options
            - all_containers:
                default: true
                overridable: false
            - excluded_images
            - host
            - port:
                required: false
            - username
            - password:
                required: false
            - private_key_file:
                required: false
            - character_set:
                required: false
            - pty:
                required: false
            - timeout:
                required: false
            - close_session:
                required: false
            - agent_forwarding:
                required: false
        publish:
          - container_ids

    - clear_containers:
        do:
          containers.clear_container:
            - container_id: container_ids.replace(",", " ")
            - docker_options
            - docker_host: host
            - port:
                required: false
            - docker_username: username
            - docker_password:
                default: password
                required: false
            - private_key_file:
                default: private_key_file
                required: false
            - timeout:
                required: false

    - clear_unused_images:
        do:
          images.clear_unused_docker_images:
            - docker_options
            - docker_host: host
            - docker_username: username
            - docker_password:
                default: password
                required: false
            - private_key_file:
                default: private_key_file
                required: false
            - timeout:
                required: false
            - port:
                required: false
        publish:
          - amount_of_images_deleted
          - amount_of_dangling_images_deleted
          - total_amount_of_images_deleted: amount_of_images_deleted + amount_of_dangling_images_deleted
  outputs:
    - amount_of_images_deleted
    - amount_of_dangling_images_deleted
    - total_amount_of_images_deleted
  results:
    - SUCCESS
    - FAILURE
