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
####################################################

namespace: io.cloudslang.amazon.aws.ec2.regions

imports:
  regions: io.cloudslang.amazon.aws.ec2.regions
  lists: io.cloudslang.base.lists
  strings: io.cloudslang.base.strings

flow:
  name: test_describe_regions

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        required: false
    - credential:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - delimiter:
        required: false
    - debug_mode:
        default: 'false'
        required: false
    - key_filters_string
    - value_filters_string
    - regions_string

  workflow:
    - describe_regions:
        do:
          regions.describe_regions:
            - provider
            - endpoint
            - identity
            - credential
            - proxy_host
            - proxy_port
            - delimiter
            - debug_mode
            - key_filters_string
            - value_filters_string
            - regions_string
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: LIST_REGION_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: check_default_region_exist
          - FAILURE: CHECK_RESULT_FAILURE

    - check_default_region_exist:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: ${return_result}
            - string_to_find: 'us-east-1'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_DEFAULT_REGION_FAILURE

  results:
    - SUCCESS
    - LIST_REGION_FAILURE
    - CHECK_RESULT_FAILURE
    - CHECK_DEFAULT_REGION_FAILURE
