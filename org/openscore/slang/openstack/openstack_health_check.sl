#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This flow will do a health check on an OpenStack machine. It creates a server, checks it is up and then deletes it.
#   If any of the steps fail it will send an email with the error report.
#
#   Inputs:
#       - host - OpenStack machine IP
#       - identityPort - optional - Port used for OpenStack authentication - Default: 5000
#       - computePort - optional - Port used for OpenStack computations - Default: 8774
#       - imgRef - Image reference for of the server to be created
#       - username - OpenStack username
#       - password - OpenStack password
#       - serverName - optional - Server name - Default: test-server
#       - emailHost - Email host
#       - emailPort - Email port
#       - to - Email recipient
#       - from - Email sender
####################################################

namespace: org.openscore.slang.openstack

imports:
  openstack_content: org.openscore.slang.openstack
  email: org.openscore.slang.base.mail

flow:
  name: openstack_health_check
  inputs:
    - host
    - identityPort:
        default: "'5000'"
        required: false
    - computePort:
        default: "'8774'"
        required: false
    - imgRef
    - username
    - password
    - serverName:
        default: "'test-server'"
        required: false
    - emailHost
    - emailPort
    - to
    - from
  workflow:
    create_server:
      do:
        openstack_content.create_openstack_server_flow:
          - host
          - identityPort
          - computePort
          - imgRef
          - username
          - password
          - serverName
      publish:
        - subflow_error: "'\"Create Server\": ' + errorMessage"
    validate_server_exists:
      do:
        openstack_content.validate_server_exists:
          - openstackHost: host
          - openstackIdentityPort: identityPort
          - openstackComputePort: computePort
          - openstackUsername: username
          - openstackPassword: password
          - serverName
      publish:
        - subflow_error : "'\"Validate Server\": ' + errorMessage"
    delete_server:
      do:
        openstack_content.delete_openstack_server_flow:
          - host
          - identityPort
          - computePort
          - username
          - password
          - serverName
      publish:
        - subflow_error : "'\"Delete Server\": ' + errorMessage"
    on_failure:
      send_error_mail:
        do:
          email.send_mail:
            - hostname: emailHost
            - port: emailPort
            - from
            - to
            - subject: "'Flow failure'"
            - body: "'Failure from step ' + subflow_error"
        navigate:
          SUCCESS: FAILURE
          FAILURE: FAILURE
