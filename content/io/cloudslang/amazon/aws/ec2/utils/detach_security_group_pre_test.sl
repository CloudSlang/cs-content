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
#! @description: This flow checks if the security group to be detached is not attached to the instance and if there is
#!                  at least one security group present after detaching. It returns the string of comma-separated
#!                  security group IDs after removing the IDs of security groups to be detached.
#!
#! @input security_grps_to_delete: The security group Ids which are to be detached from the instance.
#! @input existing_security_grps: The security group Ids which are already attached to the instance.
#!
#! @output result: The security group Ids present after removing the Ids to detach
#! @output error_message: If there is an exception or error message.
#!
#! @result SUCCESS: If the security group to be detached is not attached to the instance, and if there is at least one
#!                  security group present after detaching, it returns success.
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.utils
operation:
  name: detach_security_group_pre_test
  inputs:
    - security_grps_to_delete:
        required: true
    - existing_security_grps:
        required: false
  python_action:
    script: |-
      try:
          error_message = ""
          if(security_grps_to_delete):
              security_grps_to_delete=security_grps_to_delete.split(',')
              existing_security_grps=existing_security_grps.split(',')
              for secgrp in security_grps_to_delete:
                  if secgrp in existing_security_grps:
                      existing_security_grps.remove(secgrp)
                  else:
                      error_message="Security Group to be detached is not attached to the instance"
                      break
              if((len(existing_security_grps))<1):
                  error_message = "Atleast one security group should be present"
              result=','.join(existing_security_grps)
      except:
          error_message = "Invalid"
  outputs:
    - result
    - error_message
  results:
    - SUCCESS: '${error_message==""}'
    - FAILURE