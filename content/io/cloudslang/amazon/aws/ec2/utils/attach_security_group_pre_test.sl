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
#! @description: This operation returns success, If the number of security groups is less than or equal to 5 and
#!              the security group to be added does not already exist.
#!
#! @input security_grp_ids_new: The security group Ids which are to be attached to the instance.
#! @input security_grp_ids_old: The security group Ids which are already attached to the instance.
#!
#! @output return_result: If successful, returns a message
#! @output error_message: If there is an exception or error message.
#!
#! @result SUCCESS: If the number of security groups is less than or equal to 5 and
#!                  the security group to be added does not already exist, success is returned.
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.utils
operation:
  name: attach_security_group_pre_test
  inputs:
    - security_grp_ids_new:
        required: true
    - security_grp_ids_old:
        required: false
  python_action:
    script: |-
      try:
          error_message = ""
          return_result = ""
          if(security_grp_ids_new):
              if((len(security_grp_ids_new.split(',')))+(len(security_grp_ids_old.split(',')))>5):
                  error_message = "Security Group limit exceeded.Number of security groups for an instance should be less than or equal to 5."
              else:
                  common_security_group=0
                  security_grp_ids_new=security_grp_ids_new.split(',')
                  security_grp_ids_old=security_grp_ids_old.split(',')
                  for i in security_grp_ids_new:
                      if i in security_grp_ids_old:
                          common_security_group=1
                          break
                  if(not common_security_group):
                      return_result="The Security Groups to be added does not exist."
                  else:
                      error_message="The Security Groups to be added already exist."
      except:
          error_message = "Invalid input values."
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS: '${error_message==""}'
    - FAILURE

