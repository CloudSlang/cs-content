# (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# System property file for Amazon AWS operations
#
# io.cloudslang.cloud.amazon_aws.provider: cloud service provider
# io.cloudslang.cloud.amazon_aws.endpoint: endpoint to which the request will be sent
# io.cloudslang.cloud.amazon_aws.aws_latency: time (in seconds) to wait until launched instance is available
# io.cloudslang.cloud.amazon_aws.instance_output_id_regex: regex needed to extract instance id from 'run_instances' operation
#                                                          string formatted output
# io.cloudslang.cloud.amazon_aws.volume_output_id_xpath_query: xpath formatted string needed to extract volume id from
#                                                              'create_volume' operation string formatted xml output
# io.cloudslang.cloud.amazon_aws.volume_output_query_type: type of selection result from xpath_query
# io.cloudslang.cloud.amazon_aws.volumes_query_api_version: version of the volume web service to made the call against it
# io.cloudslang.cloud.amazon_aws.success_call_list: string formatted list that verifies the HTTP call has '0' as
#                                                   return_code and no exception message
#
####################################################

namespace: io.cloudslang.cloud.amazon_aws

properties:
  - provider: 'amazon'
  - endpoint: 'https://ec2.amazonaws.com'
  - aws_latency: '40'
  - instance_output_id_regex: 'id=[\w-]{10}'
  - success_call_list: ',0'