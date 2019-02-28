#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
# System property file for Amazon AWS operations
#
# io.cloudslang.amazon.aws.ec2.provider: cloud service provider
# io.cloudslang.amazon.aws.ec2.endpoint: endpoint to which the request will be sent
# io.cloudslang.amazon.aws.ec2.aws_latency: time (in seconds) to wait until launched instance is available
# io.cloudslang.amazon.aws.ec2.instance_output_id_regex: regex needed to extract instance id from 'run_instances'
#                                                        operation string formatted output
# io.cloudslang.amazon.aws.ec2.success_call_list: string formatted list that verifies the HTTP call has '0' as
#                                                   return_code and no exception message
#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2

properties:
  - provider: 'amazon'
  - endpoint: 'https://ec2.amazonaws.com'
  - aws_latency: '40'
  - instance_output_id_regex: 'id=[\w-]{10}'
  - success_call_list: ',0'