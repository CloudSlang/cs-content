#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
#!!
#! @description: Tests that encoding and then decoding a string by using the same character set yields the original string.
#!!#
####################################################

namespace: io.cloudslang.base.utils

imports:
  utils: io.cloudslang.base.utils
  strings: io.cloudslang.base.strings

flow:
  name: test_encoder_decoder

  inputs:
    - text
    - character_set:
        required: false
        default: 'UTF-8'

  workflow:
    - encode:
        do:
          utils.base64_encoder:
            - data: ${text}
            - character_set

        publish:
          - encoded_text: ${result}

    - decode:
        do:
          utils.base64_decoder:
            - data: ${encoded_text}
            - character_set

        publish:
          - decoded_text: ${result}

    - check:
        do:
          strings.string_equals:
            - first_string: ${decoded_text}
            - second_string: ${text}

        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: DECODED_ENCODING_MISMATCH_FAILURE

  outputs:
    - original_string: ${text}
    - coded_decoded_text: ${decoded_text}

  results:
    - SUCCESS
    - FAILURE
    - DECODED_ENCODING_MISMATCH_FAILURE
