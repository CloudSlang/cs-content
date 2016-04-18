#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves build failure from CircieCI - Github branch.
#! @input token - CircleCi user token.
#! #input protocol - https or http.
#! @input host: circleci address
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! #input username - CircleCi username.
#! #input project - Github project name.
#! #input branch - Github project branch.
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type of the
#!                      data in the message body - Default: 'application/json'
#! @input headers: optional - list containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":" - Format: According to HTTP standard for
#!                 headers (RFC 2616) - Example: 'Accept:application/json'
#! #input commiter_email - email address of the commiter.
#! #input supervisor - Github supervisor email.
#! @input hostname - email host
#! @input port - email port
#! @input from - email sender
#! @input to - email recipient
#! @input cc - optional - comma-delimited list of cc recipients - Default: none
#! @output return_result: information returned
#! @output error_message: return_result if status_code different than '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: status code of the HTTP call
#! @result SUCCESS: successful
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.ci.circleci

imports:
  rest: io.cloudslang.base.network.rest
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  lists: io.cloudslang.base.lists
  mail: io.cloudslang.base.mail

flow:
  name: get_failed_build
  inputs:
    - token
    - protocol
    - host:
        default: "circleci.com"
    - proxy_host:
        required: false
    - proxy_port:
        default: "8080"
        required: false
    - username
    - project
    - branch
    - content_type:
        default: "application/json"
    - headers:
        default: "Accept:application/json"
    - committer_email
    - supervisor
    - hostname
    - port
    - from
    - to
    - cc:
        required: false

  workflow:
    - http_client_get:
        loop:
          for: branch in ['circleci']
          do:
            rest.http_client_get:
              - url: ${protocol + '://' + host + '/api/v1/project/' + username + '/' + project + '/tree/' + branch + '?circle-token=:' + token + '&limit=1&filter=failed'}
              - protocol
              - host
              - proxy_host
              - proxy_port
              - content_type
              - headers


          publish:
            - return_result
            - return_code
            - status_code
            - error_message

        navigate:
          - SUCCESS: get_username
          - FAILURE: FAILURE

    - get_username:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: [0,'username']

        publish:
          - username: ${value}
          - error_message

        navigate:
          - SUCCESS: get_committer_email
          - FAILURE: FAILURE

    - get_committer_email:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: [0,'committer_email']

        publish:
          - committer_email: ${value}
          - error_message

        navigate:
          - SUCCESS: get_reponame
          - FAILURE: FAILURE

    - get_reponame:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: [0,'reponame']

        publish:
          - reponame: ${value}
          - error_message

        navigate:
          - SUCCESS: get_branch
          - FAILURE: FAILURE

    - get_branch:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: [0,'branch']

        publish:
          - branch: ${value}
          - error_message

        navigate:
          - SUCCESS: get_subject
          - FAILURE: FAILURE

    - get_subject:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: [0,'subject']

        publish:
          - ci_subject: ${value}
          - error_message

        navigate:
          - SUCCESS: get_build_num
          - FAILURE: FAILURE

    - get_build_num:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: [0,'build_num']

        publish:
          - build_num: ${value}
          - error_message

        navigate:
          - SUCCESS: get_commit
          - FAILURE: FAILURE

    - get_commit:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: [0,'vcs_revision']

        publish:
          - commit: ${value}
          - error_message

        navigate:
          - SUCCESS: get_outcome
          - FAILURE: FAILURE

    - get_outcome:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: [0,'outcome']

        publish:
          - outcome: ${value}
          - error_message

        navigate:
          - SUCCESS: get_failed_build
          - FAILURE: FAILURE

    - get_failed_build:
          do:
            mail.send_mail:
              - hostname
              - port
              - from
              - to: ${committer_email}
              - cc: ${supervisor}
              - subject: ${'[Build' + '] ' + 'Failed:' + username + '/' + reponame + '/' + branch}
              - htmlEmail: True
              - body: >
                  ${'<p align=center>' + 'Build failure on repository:' + reponame + '-' + 'branch:' + branch + '</p>'
                  '<table align="center" border="1" cellpadding="0" cellspacing="0" width="400">' +
                  '<tr>' +
                  '<td>' +
                  'Repository:' +
                  '</td>' +
                  '<td bgcolor="#70bbd9">' +
                  reponame +
                  '</td>' +
                  '</tr>' +
                  '<tr>' +
                  '<td>' +
                  'Branch:' +
                  '</td>' +
                  '<td>' +
                  branch +
                  '</td>' +
                  '</tr>' +
                  '<tr>' +
                  '<td>' +
                  'Username:' +
                  '</td>' +
                  '<td>' +
                  username +
                  '</td>' +
                  '</tr>' +
                  '<tr>' +
                  '<td>' +
                  'Commiter email:' +
                  '</td>' +
                  '<td>' +
                  committer_email +
                  '</td>' +
                  '</tr>' +
                  '<tr>' +
                  '<td>' +
                  'Subject:' +
                  '</td>' +
                  '<td>' +
                  ci_subject +
                  '</td>' +
                  '</tr>' +
                  '<tr>' +
                  '<td>' +
                  'Branch:' +
                  '</td>' +
                  '<td bgcolor="#ee4c50">' +
                  outcome +
                  '</td>' +
                  '</tr>' +
                  '</table>'}

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - FAILURE