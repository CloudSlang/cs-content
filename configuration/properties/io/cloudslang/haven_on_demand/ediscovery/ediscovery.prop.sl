# (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# System property file for Haven OnDemand ediscovery properties file
#
# io.cloudslang.haven_on_demand.ediscovery.api_key: Haven OnDemand eDiscovery user api key
# io.cloudslang.haven_on_demand.ediscovery.file: file that you want to extract text from
# io.cloudslang.haven_on_demand.ediscovery.add_to_text_index_api: add to text index API URl
# io.cloudslang.haven_on_demand.ediscovery.create_text_index_api: create text index API URL
# io.cloudslang.haven_on_demand.ediscovery.find_related_concepts_api: find related concepts API URL
# io.cloudslang.haven_on_demand.ediscovery.get_parametric_values_api: get parametric values API
# io.cloudslang.haven_on_demand.ediscovery.query_text_index_api: query text index API URL
# io.cloudslang.haven_on_demand.ediscovery.document_categorization_api: document categorization API URL
# io.cloudslang.haven_on_demand.ediscovery.extract_entities_api: extract entities API URL
# io.cloudslang.haven_on_demand.ediscovery.expand_container_api: expand container API URL
# io.cloudslang.haven_on_demand.ediscovery.text_extraction_api: text extraction API URL
# io.cloudslang.haven_on_demand.ediscovery.proxy_host: proxy hostname
# io.cloudslang.haven_on_demand.ediscovery.proxy_port: proxy port
# io.cloudslang.haven_on_demand.ediscovery.hostname: SMTP hostname
# io.cloudslang.haven_on_demand.ediscovery.port: SMTP port
# io.cloudslang.haven_on_demand.ediscovery.from: sender email address
# io.cloudslang.haven_on_demand.ediscovery.to: recipient email address
#
####################################################

namespace: io.cloudslang.haven_on_demand.ediscovery

properties:
  - api_key: <api_key>
  - file: <file>
  - add_to_text_index_api: "https://api.havenondemand.com/1/api/sync/addtotextindex/v1"
  - create_text_index_api: "https://api.havenondemand.com/1/api/sync/createtextindex/v1"
  - find_related_concepts_api: "https://api.havenondemand.com/1/api/sync/findrelatedconcepts/v1"
  - get_parametric_values_api: "https://api.havenondemand.com/1/api/sync/getparametricvalues/v1"
  - query_text_index_api: "https://api.havenondemand.com/1/api/sync/querytextindex/v1"
  - document_categorization_api: "https://api.havenondemand.com/1/api/sync/categorizedocument/v1"
  - extract_entities_api: "https://api.havenondemand.com/1/api/sync/extractentities/v2"
  - expand_container_api: "https://api.havenondemand.com/1/api/sync/expandcontainer/v1"
  - text_extraction_api: "https://api.havenondemand.com/1/api/sync/extracttext/v1"
  - proxy_host: <proxy_host>
  - proxy_port: <proxy_port>
  - hostname: <hostname>
  - port: <port>
  - from: <from>
  - to: <to>