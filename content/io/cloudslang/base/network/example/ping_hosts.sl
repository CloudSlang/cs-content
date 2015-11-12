# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Pings addresses from input list and sends an email with results.
#
# Prerequisites: system property file with email properties
#
# Inputs:
#   - ip_list - list of IPs to be checked
#   - message_body - the message to be sent in emails
#   - all_nodes_are_up - whether the nodes are up or not - Default: True
#   - hostname - email host - System Property: io.cloudslang.base.hostname
#   - port - email port - System Property: io.cloudslang.base.port
#   - from - email sender - System Property: io.cloudslang.base.from
#   - to - email recipient - System Property: io.cloudslang.base.to
#   - subject - email subject - Default: "'Ping Result'"
#   - username - optional - username to connect to email host - System Property: io.cloudslang.base.username
#   - password - optional - password for the username to connect to email host - System Property: io.cloudslang.base.password
#
# Results:
#   - SUCCESS - addressee will get an email with result
#   - FAILURE - addressee will get an email with exception of operation
#
####################################################
namespace: io.cloudslang.base.network.example

imports:
  network: io.cloudslang.base.network
  mail: io.cloudslang.base.mail
  strings: io.cloudslang.base.strings

flow:
  name: ping_hosts

  inputs:
    - ip_list
    - message_body: []
    - all_nodes_are_up: True
    - hostname:
        system_property: io.cloudslang.base.hostname
    - port:
        system_property: io.cloudslang.base.port
    - from:
        system_property: io.cloudslang.base.from
    - to:
        system_property: io.cloudslang.base.to
    - subject: "Ping Result"
    - username:
        system_property: io.cloudslang.base.username
        required: false
    - password:
        system_property: io.cloudslang.base.password
        required: false

  workflow:
    - check_address:
        loop:
          for: address in ip_list
          do:
            network.ping:
              - address
        publish:
          - messagebody: ${ self['message_body'].append(message) }
          - all_nodes_are_up: ${ self['all_nodes_are_up'] and is_up }
        navigate:
          UP: check_result
          DOWN: failure_mail_send
          FAILURE: failure_mail_send

    - check_result:
        do:
          strings.string_equals:
            - first_string: ${ str(all_nodes_are_up) }
            - second_string: "True"
        navigate:
          SUCCESS: mail_send
          FAILURE: failure_mail_send

    - mail_send:
        do:
          mail.send_mail:
            - hostname
            - port
            - from
            - to
            - subject
            - body: ${ "Result: " + " ".join(message_body) }
            - username
            - password

    - on_failure:
        - failure_mail_send:
            do:
              mail.send_mail:
                - hostname
                - port
                - from
                - to
                - subject
                - body: ${ 'Result: Failure to ping: ' + ' '.join(message_body) }
                - username
                - password