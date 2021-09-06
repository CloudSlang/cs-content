#   (c) Copyright 2021 Micro Focus, L.P.
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
#! @description: This workflow creates a volume and attaches it to the specified instance.
#!
#! @input provider_sap: The AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                      Default: 'https://ec2.amazonaws.com'
#! @input access_key_id: The ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: The secret access key associated with your Amazon AWS account.
#! @input instance_id: The ID of the newly created instance.
#! @input os_type: The type of platform the deployed instance is.
#! @input availability_zone: The availability zone of the instance.
#! @input volume_size: The size of volume needs to be created.
#! @input volume_type: The type of the volumes.Valid values: gp2 (for General  Purpose (SSD) volumes),
#!                     io1 (for Provisioned IOPS (SSD) volumes) and standard (for Magnetic volumes)
#!                     Default value: standard
#!                     Optional
#! @input snapshot_id: The ID of the snapshot from which to create the new volume. Specify a value for this
#!                     input if you do not specify <size> input.
#!                     Optional
#! @input encrypted: Specifies whether the volume should be encrypted.
#!                   Valid values: true and false
#!                   Default value: false
#!                   Optional
#! @input iops: The number of I/O operations per second (IOPS) to provision for the volume.
#!              Only valid for Provisioned IOPS (SSD) volumes.
#!              Valid values: from 100 to 4,000
#!              Optional
#! @input proxy_host: The proxy server used to access the provider services
#!                    Optional
#! @input proxy_port: The proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: The proxy server user name.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '10'
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: '50'
#!                         Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output volume_id: The id of volume which is created and attached to the instance.
#! @output device_name: The device name of the volume.
#! @output return_result: Contains the success message or the exception in case of failure
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The volume created and attached to the instance successfully.
#! @result FAILURE: There was an error while creating or attaching volume to the instance.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.volumes

imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  volumes: io.cloudslang.amazon.aws.ec2.volumes
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: create_and_attach_single_volume
  inputs:
    - provider_sap: 'https://ec2.amazonaws.com'
    - access_key_id
    - access_key:
        sensitive: true
    - instance_id
    - os_type
    - availability_zone
    - volume_size
    - volume_type:
        required: false
    - snapshot_id:
        required: false
    - encrypted:
        default: 'false'
        required: false
    - iops:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - polling_interval:
        default: '10'
        required: false
    - polling_retries:
        default: '50'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false

  workflow:
    - describe_instances:
        worker_group: '${worker_group}'
        do:
          instances.describe_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - availability_zone
            - instance_ids_string: '${instance_id}'
        publish:
          - instance_details: '${return_result}'
          - return_code
          - exception
          - return_result
        navigate:
          - SUCCESS: search_and_replace_1
          - FAILURE: on_failure

    - search_and_replace_1:
        worker_group: '${worker_group}'
        do:
          strings.search_and_replace:
            - origin_string: '${instance_details}'
            - text_to_replace: xmlns
            - replace_with: xhtml
        publish:
          - replaced_string
        navigate:
          - SUCCESS: parse_block_device
          - FAILURE: on_failure

    - create_volume:
        worker_group: '${worker_group}'
        do:
          volumes.create_volume:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - availability_zone: '${availability_zone}'
            - encrypted: '${encrypted}'
            - iops: '${iops}'
            - size: '${volume_size}'
            - snapshot_id: '${snapshot_id}'
            - volume_type: '${volume_type}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: search_and_replace_2
          - FAILURE: on_failure

    - check_volume_is_available_or_not:
        worker_group:
          value: '${worker_group}'
          override: true
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            volumes.check_volume_state:
              - provider_sap: '${provider_sap}'
              - access_key_id: '${access_key_id}'
              - access_key:
                  value: '${access_key}'
                  sensitive: true
              - volume_id: '${volume_id}'
              - volume_state: available
              - proxy_host: '${proxy_host}'
              - proxy_port: '${proxy_port}'
              - proxy_username: '${proxy_username}'
              - proxy_password:
                  value: '${proxy_password}'
                  sensitive: true
              - polling_interval: '${polling_interval}'
              - worker_group: '${worker_group}'
          break:
            - SUCCESS
          publish:
            - return_result
            - exception
            - return_code
        navigate:
          - FAILURE: delete_volume_in_region
          - SUCCESS: is_linux_vm

    - search_and_replace_2:
        worker_group: '${worker_group}'
        do:
          strings.search_and_replace:
            - origin_string: '${return_result}'
            - text_to_replace: xmlns
            - replace_with: xhtml
        publish:
          - replaced_string
        navigate:
          - SUCCESS: parse_volume_id
          - FAILURE: on_failure

    - parse_volume_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='CreateVolumeResponse']/*[local-name()='volumeId']"
            - query_type: value
        publish:
          - volume_id: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: check_volume_is_available_or_not
          - FAILURE: on_failure

    - parse_block_device:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='blockDeviceMapping']"
            - query_type: value
        publish:
          - block_device_mapping: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: number_of_attached_volumes
          - FAILURE: on_failure

    - number_of_attached_volumes:
        worker_group: '${worker_group}'
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '${block_device_mapping}'
            - string_to_find: vol-
        publish:
          - number_of_attached_volumes: '${return_result}'
          - return_code
          - error_message
          - return_result
        navigate:
          - SUCCESS: form_device_name_based_on_os_type
          - FAILURE: on_failure

    - form_device_name_based_on_os_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${number_of_attached_volumes}'
            - value2: '1'
        publish:
          - disk_digit: '${result}'
          - return_code
          - linux_device_name: '${"/dev/sd"+ chr(97+int(value1))}'
          - windows_device_name: '${"xvd"+ chr(97+int(value1))}'
        navigate:
          - SUCCESS: create_volume
          - FAILURE: on_failure

    - is_linux_vm:
        worker_group: '${worker_group}'
        do:
          strings.string_equals:
            - first_string: '${os_type}'
            - second_string: Linux
            - ignore_case: 'true'
            - linux_device_name: '${linux_device_name}'
        publish:
          - device_name: '${linux_device_name}'
        navigate:
          - SUCCESS: attach_volume_to_instance
          - FAILURE: is_windows_vm

    - is_windows_vm:
        worker_group: '${worker_group}'
        do:
          strings.string_equals:
            - first_string: '${os_type}'
            - second_string: windows
            - ignore_case: 'true'
            - windows_device_name: '${windows_device_name}'
        publish:
          - device_name: '${windows_device_name}'
        navigate:
          - SUCCESS: attach_volume_to_instance
          - FAILURE: on_failure

    - attach_volume_to_instance:
        worker_group: '${worker_group}'
        do:
          volumes.attach_volume_in_region:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - volume_id: '${volume_id}'
            - instance_id: '${instance_id}'
            - device_name: '${device_name}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_volume_is_in_use_or_not
          - FAILURE: detach_volume_in_region

    - check_volume_is_in_use_or_not:
        worker_group:
          value: '${worker_group}'
          override: true
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            volumes.check_volume_state:
              - provider_sap: '${provider_sap}'
              - access_key_id: '${access_key_id}'
              - access_key:
                  value: '${access_key}'
                  sensitive: true
              - volume_id: '${volume_id}'
              - volume_state: in-use
              - proxy_host: '${proxy_host}'
              - proxy_port: '${proxy_port}'
              - proxy_username: '${proxy_username}'
              - proxy_password:
                  value: '${proxy_password}'
                  sensitive: true
              - polling_interval: '${polling_interval}'
              - worker_group: '${worker_group}'
          break:
            - SUCCESS
          publish:
            - return_result
            - exception
            - return_code
        navigate:
          - FAILURE: detach_volume_in_region
          - SUCCESS: success_message

    - success_message:
        worker_group: '${worker_group}'
        do:
          utils.do_nothing:
            - volume_id: '${volume_id}'
            - instance_id: '${instance_id}'
        publish:
          - return_result: '${"The volume " + volume_id + " has been created and attached successfully to instance " + instance_id}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

    - delete_volume_in_region:
        worker_group: '${worker_group}'
        do:
          volumes.delete_volume_in_region:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - volume_id: '${volume_id}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure

    - detach_volume_in_region:
        worker_group: '${worker_group}'
        do:
          volumes.detach_volume_in_region:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - volume_id: '${volume_id}'
            - instance_id: '${instance_id}'
            - device_name: '${device_name}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: delete_volume_in_region
          - FAILURE: on_failure

  outputs:
    - volume_id
    - device_name
    - return_result
    - return_code
    - exception

  results:
    - SUCCESS
    - FAILURE

extensions:
  graph:
    steps:
      check_volume_is_in_use_or_not:
        x: 421
        'y': 531
      form_device_name_based_on_os_type:
        x: 592
        'y': 66
      search_and_replace_1:
        x: 172
        'y': 71
      is_windows_vm:
        x: 411
        'y': 218
      search_and_replace_2:
        x: 738
        'y': 218
      describe_instances:
        x: 37
        'y': 69
      success_message:
        x: 199
        'y': 528
        navigate:
          be6477be-05f3-628a-44d7-2642261d1267:
            targetId: fdd302ed-9e53-7293-71e1-e21513d1e57b
            port: SUCCESS
      attach_volume_to_instance:
        x: 415
        'y': 379
      number_of_attached_volumes:
        x: 457
        'y': 66
      check_volume_is_available_or_not:
        x: 601
        'y': 378
      parse_block_device:
        x: 313
        'y': 70
      parse_volume_id:
        x: 743
        'y': 368
      detach_volume_in_region:
        x: 614
        'y': 523
      is_linux_vm:
        x: 594
        'y': 227
      delete_volume_in_region:
        x: 751
        'y': 519
        navigate:
          0af273b2-ae37-bfbf-2a94-002756c0a515:
            targetId: 35a768f7-4ebe-feb6-e55f-e24373d72554
            port: SUCCESS
      create_volume:
        x: 736
        'y': 71
    results:
      SUCCESS:
        fdd302ed-9e53-7293-71e1-e21513d1e57b:
          x: 196
          'y': 379
      FAILURE:
        35a768f7-4ebe-feb6-e55f-e24373d72554:
          x: 933
          'y': 523
