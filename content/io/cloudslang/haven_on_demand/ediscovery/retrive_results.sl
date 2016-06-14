#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Retrieves links from document
#! @input document:
#! @output link: links of content, witch was found
#! @output content: information about content, witch was found. (it contains name and link)
#!!#
####################################################
namespace: io.cloudslang.haven_on_demand.ediscovery

operation:
  name: retrive_results
  inputs:
    - document
  python_action:
    script: |
      origin_string = str(document[0]['content'])
      list = origin_string.split(" ")
      index1 = list.index("namespace:") + 1
      namespace = list[index1]
      index2 = list.index("name:") + 1
      name = list[index2]
      path = namespace.replace(".", "/") + '/' + name + '.sl'
      link = "https://github.com/CloudSlang/cloud-slang-content/tree/master/content/" + path
      content = []
      content.append(name)
      content.append(link)
  outputs:
     - link
     - content
