#   (c) Copyright 2020 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Checks the date when a file was last modified.
#!
#! @input source: The file for which to check modification date.
#! @input threshold: The date to compare to. For example: \"July 13, 2020 10:04:08 AM\" in English date format ( other
#!                   country specific date formats are also recognized ).
#! @input locale_lang: The locale language used to format the result date . For example,  en or ja.
#! @input locale_country: The locale country used to format the result date. For example, US or JP.
#!
#! @output date: The date when the file was last modified. The date will be formatted using the values provided in
#!               the localeLang and localeCountry inputs. If values are not provided in both inputs or the locale values are invalid , the date will be
#!               returned in the "MM/dd/yyyy hh:mm:ss a" format
#! @output return_result: A message indicating that the operation executed successfully or an error message otherwise.
#! @output return_code: 0 in case the file is older than the threshold, 1 in case the file last modified date is the same as the threshold,
#!                      2 in case the file is more recent than the threshold, -1 in case of failure
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#!
#! @result FAILURE: The operation failed.
#! @result LESS_THAN: The file is older than the threshold.
#! @result EQUAL_TO: The file last modified date is the same as the threshold.
#! @result GREATER_THAN: The file is more recent than the threshold.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: get_modified_date

  inputs:
    - source
    - threshold
    - locale_lang:
        required: false
    - localeLang:
        default: ${get("locale_lang", "")}
        required: false
        private: true
    - locale_country:
        required: false
    - localeCountry:
        default: ${get("locale_country", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-filesystem:0.0.1'
    class_name: io.cloudslang.content.filesystem.actions.GetModifiedDateAction
    method_name: execute

  outputs:
    - date: ${date}
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get('exception', '')}

  results:
    - LESS_THAN: ${returnCode == '0'}
    - EQUAL_TO: ${returnCode == '1'}
    - GREATER_THAN: ${returnCode == '2'}
    - FAILURE