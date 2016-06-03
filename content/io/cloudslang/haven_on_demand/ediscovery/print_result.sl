#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Prints document from Haven OnDemand
#! @input api_key: user's API Keys
#! @input reference: A Haven OnDemand reference obtained from either the Expand Container or Store Object API. The corresponding document is passed to the API.
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery

imports:
     ediscovery: io.cloudslang.haven_on_demand.ediscovery
     file: io.cloudslang.base.files
     base: io.cloudslang.base.print
flow:
  name: print_result

  inputs:
     - api_key:
        sensitive: true
     - reference
  workflow:
     - text_extraction:
         do:
           ediscovery.text_extraction.text_extraction:
               - api_key
               - reference
         publish:
           - error_message
           - document
           - return_code

     - print_doc:
           do:
             base.print_text:
                - text: ${document}
