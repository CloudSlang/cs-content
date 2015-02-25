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
#       - host - OpenStack machine host
#       - identity_port - optional - port used for OpenStack authentication - Default: 5000
#       - compute_port - optional - port used for OpenStack computations - Default: 8774
#       - img_ref - image reference of the server to be created
#       - username - OpenStack username
#       - password - OpenStack password
#       - server_name - optional - server name - Default: test-server
#       - email_host - email host
#       - email_port - email port
#       - to - email recipient
#       - from - email sender
####################################################

namespace: org.openscore.slang.openstack

imports:
  openstack_content: org.openscore.slang.openstack
  email: org.openscore.slang.base.mail

flow:
  name: openstack_health_check
  inputs:
    - host
    - identity_port:
        default: "'5000'"
    - compute_port:
        default: "'8774'"
    - img_ref
    - username
    - password
    - server_name:
        default: "'test-server'"
    - email_host
    - email_port
    - to
    - from
  workflow:
    - create_server:
        do:
          openstack_content.create_openstack_server_flow:
            - host
            - identity_port
            - compute_port
            - img_ref
            - username
            - password
            - server_name
        publish:
          - subflow_error: "'\"Create Server\": ' + error_message"
    - validate_server_exists:
        do:
          openstack_content.validate_server_exists:
            - openstack_host: host
            - openstack_identity_port: identity_port
            - openstack_compute_port: compute_port
            - openstack_username: username
            - openstack_password: password
            - server_name
        publish:
          - subflow_error : "'\"Validate Server\": ' + error_message"
    - delete_server:
        do:
          openstack_content.delete_openstack_server_flow:
            - host
            - identity_port
            - compute_port
            - username
            - password
            - server_name
        publish:
          - subflow_error : "'\"Delete Server\": ' + error_message"
    - on_failure:
        - send_error_mail:
            do:
              email.send_mail:
                - hostname: email_host
                - port: email_port
                - from
                - to
                - subject: "'Flow failure'"
                - body: "'Failure from step ' + subflow_error"
            navigate:
              SUCCESS: FAILURE
              FAILURE: FAILURE
