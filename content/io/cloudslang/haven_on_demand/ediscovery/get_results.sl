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
     mail: io.cloudslang.base.mail
flow:
  name: get_results

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

     - retrive_results:
           do:
             retrive_results:
                - document
           publish:
             - link
             - content

     - write_to_db:
         do:
          file.add_text_to_file:
             - file_path: "C:/Temp/result.txt"
             - text: ${" link " + content[1] + " \n"}
         publish:
           - error_message: ${message}
