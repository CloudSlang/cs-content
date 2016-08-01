#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates a Haven OnDemand text index and indexes the given video files.
#!
#! @input api_key: API key
#! @input files_info: list of video file information in the following format
#!                    format:  [{"title": <title>, "url": <url>, "path": <path>}, ...]
#! @input index: name of text index to create
#!               default: video_library
#! @input description: description of the index
#!                     default: Video+library+transcripts
#! @input proxy_host: proxy server
#!                    optional
#! @input proxy_port: proxy server port
#!                    optional
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.examples.video_text_search

imports:
  files: io.cloudslang.base.files
  print: io.cloudslang.base.print
  hod: io.cloudslang.haven_on_demand

flow:
  name: setup_index

  inputs:
    - api_key:
        default: ${get_sp('io.cloudslang.haven_on_demand.examples.video_text_search.api_key')}
        sensitive: true
    - files_info
    - index:
        default: "video_library"
        required: false
    - description:
        default: "Video+library+transcripts"
        required: false
    - proxy_host:
        default: ${get_sp('io.cloudslang.haven_on_demand.examples.video_text_search.proxy_host', '')}
        required: false
    - proxy_port:
        default: ${get_sp('io.cloudslang.haven_on_demand.examples.video_text_search.proxy_port', '')}
        required: false

  workflow:
    - create_index:
        do:
          hod.unstructured_text_indexing.create_text_index:
          - api_key
          - index
          - flavor: "standard"
          - description
          - proxy_host
          - proxy_port
        publish:
          - error_message
          - return_result
    - add_files:
        loop:
          for: video in files_info
          do:
            hod.examples.video_text_search.add_to_index:
              - api_key
              - file: ${video['path']}
              - title: ${video['title']}
              - url: ${video['url']}
              - index
              - proxy_host
              - proxy_port
          publish:
            - error_message
            - return_result
    - on_failure:
        - print_fail:
            do:
              print.print_text:
                  - text: ${"Error - " + error_message}
