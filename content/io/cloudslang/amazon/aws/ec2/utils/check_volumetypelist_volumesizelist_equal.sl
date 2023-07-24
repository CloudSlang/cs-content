#   (c) Copyright 2023 Open Text
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
#! @description: Checks if number of comma separated values in volume type list is equal to that of volume size list.
#!
#! @input volume_type_list: The volume_type_list separated by comma(,)The length of the items volume_type_list must be equal with the length of the items volume_size_list .Valid Values: "gp2", "gp3" "io1", "io2", "st1", "sc1", or "standard".
#!                          Optional
#! @input volume_size_list: Volume size in GB ,The volume_size_list separated by comma(,)The length of the items volume_size_list  must be equal with the length of the items .Constraints: 1-16384 for General Purpose SSD ("gp2"), 4-16384 for Provisioned IOPS SSD ("io1"),500-16384 for Throughput Optimized HDD ("st1"), 500-16384 for Cold HDD ("sc1"), and 1-1024 forMagnetic ("standard") volumes.
#!                          If you specify a snapshot, the volume size must be equal to orlarger than the snapshot size. If you are creating the volume from a snapshot and don't specifya volume size, the default is the snapshot size. 
#!                          Optional
#!
#! @output return_result: If successful, returns a message
#! @output error_message: If there is an exception or error message.
#!
#! @result SUCCESS: volume_type and volume_size list matched
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.utils
operation:
  name: check_volumetypelist_volumesizelist_equal
  inputs:
    - volume_type_list:
        required: false
    - volume_size_list:
        required: false
  python_action:
    script: |-
      try:
          error_message = ""
          return_result = ""
          if(volume_type_list):
              if(len(volume_type_list.split(','))==len(volume_size_list.split(','))):
                  return_result = "volume_type_list and volume_size_list matched"
              else:
                  error_message = "Invalid input value. Number of comma separated values in volume_type_list should be equal to that of volume_size_list"
      except:
          error_message = "Invalid input value. Number of comma separated values in volume_type_list should be equal to that of volume_size_list"
  outputs:
    - return_result
    - error_message
  results:
    - SUCCESS: '${error_message==""}'
    - FAILURE

