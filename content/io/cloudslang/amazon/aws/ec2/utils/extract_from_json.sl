#   (c) Copyright 2023 Micro Focus, L.P.
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
#! @description: From the input json response, this flow extracts and returns a string of comma-separated 
#!              security group ids that are attached to the instance.
#!
#! @input json_response: The input Json response from which security group Ids are to be extracted.
#!
#! @output result: This contains the security group Ids which are already attached to the instance.
#!
#! @result SUCCESS: If success, it returns the existing security group IDs.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2.utils
operation:
  name: extract_from_json
  inputs:
    - json_response
  python_action:
    use_jython: false
    script: |-
      import json
      def execute(json_response):
          data = json.loads(json_response)
          group_ids = ""
          x=data["DescribeInstancesResponse"]["reservationSet"]["item"]["instancesSet"]["item"]["groupSet"]["item"]
          if type(x) is list:
              for item in x:
                  group_ids=group_ids+item["groupId"]+","
              group_ids=group_ids[:-1]
              return {"result":group_ids}
          else:
              return {"result": x["groupId"]}
  outputs:
    - result
  results:
    - SUCCESS

