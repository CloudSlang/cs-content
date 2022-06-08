#   (c) Copyright 2022 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: list the subnets.
#!
#! @input json_data: Json data file.
#! @input vpc_id: The IDs of the groups that you want to describe.
#!
#! @output subnet_list: returns list of subnets.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.vpc.subnets
operation:
  name: get_subnet_list
  inputs:
    - json_data:
        required: true
    - vpc_id
  python_action:
    use_jython: false
    script: |-
      import json

      def execute(json_data,vpc_id):
          return_code = 0
          finallist = []
          error_message = ''
          isArray = "[" in json_data
          try:
              json_load = (json.loads(json_data))
              data=json_load['DescribeSubnetsResponse']['subnetSet']['item']
              if (isArray):
                  for x in data:
                      List = []
                      List.append(x['subnetId'])
                      List.append(x['availabilityZone'])
                      List.append(x['vpcId'])
                      List.append(x['defaultForAz'])
                      if vpc_id in x['vpcId']:
                          finallist.append(List)
              else:
                  finallist.append(data['subnetId'])
                  finallist.append(data['availabilityZone'])
                  finallist.append(data['vpcId'])
                  finallist.append(data['defaultForAz'])
          except Exception as e:
              return_code = 1
              error_message = str(e)
          return{"subnet_list":finallist, "return_code": return_code, "error_message": error_message}
  outputs:
    - subnet_list
    - return_code
    - error_message
  results:
    - SUCCESS
