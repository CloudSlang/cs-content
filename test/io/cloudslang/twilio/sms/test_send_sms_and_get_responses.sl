#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
namespace: io.cloudslang.twilio.sms
flow:
  name: test_send_sms_and_get_responses
  inputs:
    - recipients
    - expected_responses
  workflow:
    - send_sms_and_get_responses:
        do:
          io.cloudslang.twilio.sms.send_sms_and_get_responses:
            - recipients: ${recipients}
            - message: 'How many will attend?'
            - account_sid: ${get_sp('io.cloudslang.twilio.sms.account_sid')}
            - auth_token: ${get_sp('io.cloudslang.twilio.sms.auth_token')}
            - twilio_num: ${get_sp('io.cloudslang.twilio.sms.twilio_phone_number')}
            - proxy_host: ${get_sp('io.cloudslang.twilio.sms.proxy_host')}
            - proxy_port: ${get_sp('io.cloudslang.twilio.sms.proxy_port')}
        publish:
          - actual_responses: '${responses}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: compare_responses
    - compare_responses:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: ${expected_responses}
            - second_string: ${actual_responses}
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
