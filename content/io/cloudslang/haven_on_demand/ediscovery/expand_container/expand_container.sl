#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: The Expand Container API extracts content from container files (that is, files that contain a set of other files, such as ZIP or TAR archives, and PST files).
#! @input api_key: user's API Keys
#! @input expand_container_api:
#! @input file: The container file to expand.
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @output error_message: error message if there was an error when executing, empty otherwise
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery.expand_container

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
  file: io.cloudslang.base.files
  base: io.cloudslang.base.print
  ediscovery: io.cloudslang.haven_on_demand.ediscovery

flow:
  name: expand_container

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.api_key')}
        sensitive: true
    - expand_container_api: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.expand_container_api')}
    - file: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.file')}
    - proxy_host:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.proxy_host')}
        required: false
    - proxy_port:
        default: ${get_sp('io.cloudslang.haven_on_demand.ediscovery.proxy_port')}
        required: false

  workflow:

      - expand_container:
          do:
            http.http_client_action:
              - url: ${str(expand_container_api)}
              - method: POST
              - proxy_host
              - proxy_port
              - multipart_bodies: ${"apikey=" + str(api_key)}
              - multipart_files: ${file}

          publish:
              - error_message
              - return_result
              - return_code

          navigate:
             - SUCCESS: get_results
             - FAILURE: FAILURE

      - get_results:
          do:
            ediscovery.get_docs_references:
             - json_input: ${return_result}
             - key: "files"
          publish:
             - references
             - error_message

      - on_failure:
            - print_fail:
                  do:
                    base.print_text:
                      - text: "${error_message}"
  outputs:
      - references
      - error_message
