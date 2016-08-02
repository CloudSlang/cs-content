#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves build failure from CircieCI - Github project - branches.
#!               If the latest build has failed, it will send an email,
#!               to the supervisor and commiter with the following:
#!               Example:
#!                        Repository: repository name
#!                        Branch: branch name
#!                        Username: github username
#!                        Commiter email: email of github username
#!                        Subject: Last commit subject
#!                        Branch: failed
#!               If the last build from a branch has not failed, it will send an email to reflect that.
#! @input token: CircleCi user token.
#!                To authenticate, add an API token using your account dashboard
#!                Log in to CircleCi: https://circleci.com/vcs-authorize/
#!                Go to : https://circleci.com/account/api and copy the API token.
#!                If you don`t have any token generated, enter a new token name and then click on
#! @input protocol: optional - connection protocol
#!                  valid: 'http', 'https'
#!                  default: 'https'
#! @input host: circleci address
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trustAllRoots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: changeit
#! @input keystore: optional - the pathname of the Java KeyStore file. You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: optional - the password associated with the KeyStore file. If trustAllRoots is false and keystore
#!                           is empty, keystorePassword default will be supplied.
#!                           Default value: changeit
#! #input username: circleCi username.
#! #input project: github project name.
#! #input branches: github project branches.
#! @input content_type: optional - content type that should be set in the request header, representing the MIME-type of the
#!                      data in the message body - Default: 'application/json'
#! @input headers: optional - list containing the headers to use for the request separated by new line (CRLF);
#!                 header name - value pair will be separated by ":" - Format: According to HTTP standard for
#!                 headers (RFC 2616) - Example: 'Accept:application/json'
#! #input commiter_email: email address of the commiter.
#! #input supervisor: github supervisor email.
#! @input hostname: email host
#! @input port: email port
#! @input from: email sender
#! @input to: email recipient
#! @input cc: optional - comma-delimited list of cc recipients - Default: Supervisor email.
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
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json
  mail: io.cloudslang.base.mail
  circleci: io.cloudslang.ci.circleci

flow:
  name: get_branches_build_failure
  inputs:
    - token:
        sensitive: true
    - protocol:
        default: "https"
    - host:
        default: "circleci.com"
        private: true
    - proxy_host:
        required: false
    - proxy_port:
        default: "8080"
        required: false
    - trust_keystore:
        default: ${get_sp('io.cloudslang.base.http.trust_keystore')}
        required: false
    - trust_password:
        default: ${get_sp('io.cloudslang.base.http.trust_password')}
        required: false
        sensitive: true
    - keystore:
        default: ${get_sp('io.cloudslang.base.http.keystore')}
        required: false
    - keystore_password:
        default: ${get_sp('io.cloudslang.base.http.keystore_password')}
        required: false
        sensitive: true
    - content_type:
        default: "application/json"
        private: true
    - headers:
        default: "Accept:application/json"
        private: true
    - username
    - project
    - committer_email
    - branch:
        default: ''
        required: false
    - branches:
        default: ''
        required: false
    - supervisor
    - hostname
    - port
    - from
    - to
    - cc:
        required: false

  workflow:
    - get_project_branches:
        do:
          circleci.get_project_branches:
            - url: ${protocol + '://' + host + '/api/v1/projects?circle-token=' + token}
            - protocol
            - host
            - token
            - proxy_host
            - proxy_port
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - content_type
            - headers

        publish:
          - branches
          - error_message
          - return_result

        navigate:
          - SUCCESS: get_branches_build_failure
          - FAILURE: FAILURE

    - get_branches_build_failure:
        loop:
          for: branch in branches
          do:
            circleci.get_failed_build:
              - url: ${protocol + '://' + host + '/api/v1/project/' + username + '/' + project + '/tree/' + branch + '?circle-token=:' + token + '&limit=1&filter=failed'}
              - token
              - protocol
              - host
              - branch
              - committer_email
              - proxy_host
              - proxy_port
              - trust_all_roots: "false"
              - x_509_hostname_verifier: "strict"
              - trust_keystore
              - trust_password
              - keystore
              - keystore_password
              - username
              - project
              - branches
              - supervisor
              - hostname
              - port
              - from
              - to
              - cc: ${supervisor}

          publish:
            - return_result
            - return_code
            - status_code
            - error_message

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - FAILURE
