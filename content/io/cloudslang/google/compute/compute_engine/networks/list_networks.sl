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
#!!
#! @description: This operation can be used to retrieve the list of network resource, as JSON array.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input filter: Sets a filter expression for filtering listed resources, in the form filter={expression}.
#!                Your {expression} must be in the format: field_name comparison_string literal_string.
#!                The field_name is the name of the field you want to compare. Only atomic field types are
#!                supported (string, number, boolean). The comparison_string must be either eq (equals) or ne
#!                (not equals). The literal_string is the string value to filter to. The literal value must
#!                be valid for the type of field you are filtering by (string, number, boolean). For string
#!                fields, the literal value is interpreted as a regular expression using RE2 syntax. The
#!                literal value must match the entire field.
#!                For example, to filter for instances that do not have a name of example-instance, you would
#!                use filter=name ne example-instance.
#!                You can filter on nested fields. For example, you could filter on instances that have set
#!                the scheduling.automaticRestart field to true. Use filtering on nested fields to take
#!                advantage of labels to organize and search for results based on label values.
#!                To filter on multiple expressions, provide each separate expression within parentheses. For
#!                example, (scheduling.automaticRestart eq true) (zone eq us-central1-f). Multiple
#!                expressions are treated as AND expressions, meaning that resources must match all
#!                expressions to pass the filters.
#!                Optional
#! @input order_by: Sorts list results by a certain order. By default, results are returned in alphanumerical
#!                  order based on the resource name.
#!                  You can also sort results in descending order based on the creation timestamp using
#!                  orderBy='creationTimestamp desc'. This sorts results based on the creationTimestamp field
#!                  in reverse chronological order (newest result first). Use this to sort resources like
#!                  operations so that the newest operation is returned first.
#!                  Currently, only sorting by name or creationTimestamp desc is supported.
#!                  Optional
#! @input access_token: The access token from get_access_token.
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input pretty_print: Whether to format the resulting JSON.
#!                      Valid: 'true', 'false'
#!                      Default: 'true'
#!                      Optional
#!
#! @output return_result: A JSON list containing the Networks information.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The Networks were found and successfully retrieved.
#! @result FAILURE: The Networks were not found or some inputs were given incorrectly.
#!
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.compute_engine.networks

operation:
  name: list_networks

  inputs:
    - project_id
    - projectId:
        default: ${get('project_id', '')}
        required: false
        private: true
    - filter:
        default: ''
        required: false
    - order_by:
        default: ''
        required: false
    - orderBy:
        default: ${get('order_by', '')}
        required: false
        private: true
    - access_token:
        sensitive: true
    - accessToken:
        default: ${get('access_token', '')}
        required: false
        private: true
        sensitive: true
    - proxy_host:
        default: ''
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        default: '8080'
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        default: ''
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        default: ''
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true
    - pretty_print:
        default: 'true'
        required: false
    - prettyPrint:
        default: ${get('pretty_print', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-google:0.4.2'
    class_name: io.cloudslang.content.google.actions.compute.compute_engine.networks.NetworksList
    method_name: execute

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
