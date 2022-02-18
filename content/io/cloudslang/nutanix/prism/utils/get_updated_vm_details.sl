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
#! @description: Returns the VM name, host UUID, memory, vcpu, cores per cpu, timezone and agentVM values.
#!
#! @input vm_json_object: VM details in JSON format.
#!
#! @output vm_name: Name of the Virtual Machine that will be created.
#! @output host_uuids: UUIDs identifying the host on which the Virtual Machine is currently running.
#! @output vm_memory_size: The memory amount (in GiB) attached to the virtual machine that will will be created.
#! @output num_vcpus: The number that indicates how many processors will have the virtual machine that will be created.
#! @output num_cores_per_vcpu: This is the number of cores per vCPU.
#! @output time_zone: The timezone in which the Virtual Machine will be created.
#! @output agent_vm: Indicates whether the VM is an agent VM.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################
namespace: io.cloudslang.nutanix.prism.utils
flow:
  name: get_updated_vm_details
  inputs:
    - vm_json_object
  workflow:
    - get_vm_name:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vm_json_object}'
            - json_path: name
        publish:
          - vm_name: '${return_result}'
        navigate:
          - SUCCESS: get_host_uuids
          - FAILURE: on_failure
    - get_host_uuids:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vm_json_object}'
            - json_path: affinity.host_uuids
        publish:
          - host_uuids: '${return_result}'
        navigate:
          - SUCCESS: get_vm_memory
          - FAILURE: on_failure
    - get_timezone:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vm_json_object}'
            - json_path: timezone
        publish:
          - timezone: '${return_result}'
        navigate:
          - SUCCESS: get_is_agent_vm
          - FAILURE: on_failure
    - get_vm_memory:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vm_json_object}'
            - json_path: memory_mb
        publish:
          - vm_memory_in_mb: '${return_result}'
        navigate:
          - SUCCESS: divide_numbers
          - FAILURE: on_failure
    - get_num_cores_per_vcpu:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vm_json_object}'
            - json_path: num_cores_per_vcpu
        publish:
          - num_cores_per_vcpu: '${return_result}'
        navigate:
          - SUCCESS: get_timezone
          - FAILURE: on_failure
    - get_vm_vcpus:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vm_json_object}'
            - json_path: num_vcpus
        publish:
          - num_vcpus: '${return_result}'
        navigate:
          - SUCCESS: get_num_cores_per_vcpu
          - FAILURE: on_failure
    - get_is_agent_vm:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${vm_json_object}'
            - json_path: vm_features.AGENT_VM
        publish:
          - agent_vm: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - divide_numbers:
        do:
          io.cloudslang.base.math.divide_numbers:
            - value1: '${vm_memory_in_mb}'
            - value2: '1024'
        publish:
          - vm_memory: '${result}'
        navigate:
          - ILLEGAL: FAILURE
          - SUCCESS: get_vm_vcpus
  outputs:
    - vm_name: '${vm_name}'
    - host_uuids: '${host_uuids}'
    - vm_memory_size: '${vm_memory}'
    - num_vcpus: '${num_vcpus}'
    - num_cores_per_vcpu: '${num_cores_per_vcpu}'
    - time_zone: '${timezone}'
    - agent_vm: '${agent_vm}'
  results:
    - FAILURE
    - SUCCESS
