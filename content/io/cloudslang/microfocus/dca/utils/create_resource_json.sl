#   (c) Copyright 2019 Micro Focus, L.P.
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
#! @description: This utility operation is used to create a JSON representation of a DCA resource for use in the
#!               deploy_template operation.
#!
#! @input type_uuid: The UUID of the resource type.
#! @input deploy_sequence: A number (starting at 1) representing at which step the resource deployment should occur.
#! @input base_resource_uuid_list: The list of base resource UUIDs from uCMDB.
#! @input base_resource_ci_type_list: The list of uCMDB ciTypes of the base resources.
#! @input base_resource_type_uuid_list: The list of resource type UUIDs for the base resources.
#!                                      Optional
#! @input deployment_parameter_name_list: List of deployment parameter names.
#!                                        Optional
#! @input deployment_parameter_value_list: List of deployment parameter values.
#!                                         Optional
#! @input delimiter: The delimiter used in the above lists.
#!                   Default: ','
#!                   Optional
#!
#! @output return_result: A JSON representation of a DCA Resource, to use in the Deploy Template Operation.
#! @output return_code: The return code of the operation, 0 in case of success, -1 in case of failure
#! @output exception: In case of failure, the error message, otherwise empty.
#!
#! @result SUCCESS: Operation succeeded, returnCode is '0'.
#! @result FAILURE: Operation failed, returnCode is '-1'.
#!!#
########################################################################################################################

namespace: io.cloudslang.microfocus.dca.utils

operation:
  name: create_resource_json

  inputs:
    - type_uuid
    - typeUuid:
        default: ${get('type_uuid', '')}
        required: false
        private: true
    - deploy_sequence
    - deploySequence:
        default: ${get('deploy_sequence', '')}
        required: false
        private: true
    - base_resource_uuid_list:
        required: false
    - baseResourceUuidList:
        default: ${get('base_resource_uuid_list', '')}
        required: false
        private: true
    - base_resource_ci_type_list:
        required: false
    - baseResourceCiTypeList:
        default: ${get('base_resource_ci_type_list', '')}
        required: false
        private: true
    - base_resource_type_uuid_list:
        required: false
    - baseResourceTypeUuidList:
        default: ${get('base_resource_type_uuid_list', '')}
        required: false
        private: true
    - deployment_parameter_name_list:
        required: false
    - deploymentParameterNameList:
        default: ${get('deployment_parameter_name_list', '')}
        required: false
        private: true
    - deployment_parameter_value_list:
        required: false
    - deploymentParameterValueList:
        default: ${get('deployment_parameter_value_list', '')}
        required: false
        private: true
    - delimiter:
        default: ','
        required: false
    
  java_action:
    gav: 'io.cloudslang.content:cs-microfocus-dca:1.1.1'
    class_name: 'io.cloudslang.content.dca.actions.utils.CreateResourceJSON'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
