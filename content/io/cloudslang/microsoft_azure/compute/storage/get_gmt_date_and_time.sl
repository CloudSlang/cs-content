#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs an HTTP request to retrieve the current UTC date and time
#!
#! @input locale_lang: optional - the locale language
#! @input locale_country: optional - the locale country
#!
#! @output date: the current UTC date and time
#!
#! @result SUCCESS: the current date/time was obtained successfully
#! @result FAILURE: failed to obtain the current date/time
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft_azure.compute.storage

imports:
  datetime: io.cloudslang.base.datetime
  strings: io.cloudslang.base.strings

flow:
  name: get_gmt_date_and_time

  inputs:
    - locale_lang:
        default: 'en'
    - locale_country:
        default: 'US'

  workflow:
    - get_gmt_date_and_time:
        do:
         datetime.get_time:
            - locale_lang
            - locale_country
        publish:
          - output: ${return_result}
        navigate:
          - SUCCESS: convert_date_and_time
          - FAILURE: FAILURE

    - convert_date_and_time:
        do:
          datetime.parse_date:
            - date: ${output}
            - out_format: 'EEE, dd MMM yyyy HH:mm:ss z'
            - date_locale_lang: ${locale_lang}
            - date_locale_country: ${locale_country}
            - out_locale_lang: 'en'
            - out_locale_country: 'GB'
        publish:
            - date: ${result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - date

  results:
      - SUCCESS
      - FAILURE

