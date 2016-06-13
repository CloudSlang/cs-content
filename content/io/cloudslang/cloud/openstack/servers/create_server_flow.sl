#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Creates an OpenStack server.
#! @input host: OpenStack host
#! @input compute_port: optional - port used for OpenStack computations - Default: '8774'
#! @input identity_port: optional - port used for OpenStack authentication - Default: '5000'
#! @input username: optional - username used for URL authentication; for NTLM authentication - Format: 'domain\user'
#! @input password: optional - password used for URL authentication
#! @input proxy_host: optional - proxy server used to access OpenStack services
#! @input proxy_port: optional - proxy server port used to access OpenStack services - Default: '8080'
#! @input proxy_username: optional - user name used when connecting to proxy
#! @input proxy_password: optional - proxy server password associated with <proxy_username> input value
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trustAllRoots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: changeit
#! @input keystore: optional - the pathname of the Java KeyStore file. You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: optional - the password associated with the KeyStore file. If trustAllRoots is false and keystore
#!                           is empty, keystorePassword default will be supplied.
#!                           Default value: changeit
#! @input tenant_name: name of OpenStack project where the new server will be created
#! @input version: - the OpenStack API version - Examples: '2', '2.1' - Default: '2'
#! @input server_name: name of the new server
#! @input img_ref: image reference for server to be created - Example: b67f9da0-4a89-4588-b0f5-bf4d19401743
#! @input flavor_ref: - the flavor to use for the new server. You can specify this as a simple ID or a complete URI
#!                    - Examples: 1, 2, 3, 4, 5, 42, 84 - Default: '42'
#! @input boot_index: - the order in which a hyper-visor tries devices when it attempts to boot the guest from storage.
#!                      To disable a device from booting, the boot index of the device should be a negative value
#!                    - Default: '0'
#! @input uuid: uuid of the image to boot from - Example: 'b67f9da0-4a89-4588-b0f5-bf4d1940174'
#! @input source_type: the source type of the volume - Valid: '', 'image', 'snapshot' or 'volume' - Default: ''
#! @input delete_on_termination: if True then the boot volume will be deleted when the server is destroyed, If false the
#!                               boot volume will be deleted when the server is destroyed - Default: True
#! @input availability_zone: - The availability zone from which to launch the server - Example: 'nova', 'us-east1'
#!                           - Default: 'nova'
#! @input admin_pass: optional - The new created server administrator password. If this password does not meet the system
#!                               security requirements, the server can enter an 'ERROR' state. If this password does not
#!                               meet the requirements, it might be ignored and a new random password is generated.
#!                             - Default: ''
#! @input key_name: optional - The name of the security keypair used with the new created server - Default: ''
#!                           - Example: 'MyKey'
#! @input user_data: optional - A string that contains configuration information or scripts to use upon launch. Must be
#!                              Base64 encoded. The first line in the script should be "#!/bin/sh" - Default: ''
#!                            - Example: 'IyEvYmluL3NoCmFwdC1nZXQgdXBkYXRlCmFwdC1nZXQgaW5zdGFsbCBnaXQgLXk='
#! @input metadata: optional - A JSON object which defines name:value metadata pairs for the new server. The maximum
#!                             size of the metadata key and value is 255 bytes each - Default: ''
#!                           - Example: {"My Server Name": "Apache1", "min_ram": "2"}
#! @input security_groups: optional - A JSON array of objects, each describing a security group. A server can be placed
#!                                    in multiple security groups, associating each of the security groups rules with the
#!                                    server. Specify the name of the security group in the name attribute. If you omit
#!                                    this attribute, the API creates the server in the default security group
#!                                  - Example: {"name":"group1"},{"name":"group2"} - Default: {"name":"default"}
#! @input personality: optional - A JSON Array of objects each defining a file to inject into the new server file system.
#!                                The "contents" value is Base64 encoded - Default: '' - Example: {"path": "/etc/banner.txt",
#!                                "contents": "ICAgICAgDQoiQSBjbG91ZCBkb2VzIG5vdCBrbm93IHdoeSBpdCBtb3ZlcyBpbiBqdXN0IHN1Y
#!                                2ggYSBkaXJlY3Rpb24gYW5kIGF0IHN1Y2ggYSBzcGVlZC4uLkl0IGZlZWxzIGFuIGltcHVsc2lvbi4uLnRoaXM
#!                                gaXMgdGhlIHBsYWNlIHRvIGdvIG5vdy4gQnV0IHRoZSBza3kga25vd3MgdGhlIHJlYXNvbnMgYW5kIHRoZSBwY
#!                                XR0ZXJucyBiZWhpbmQgYWxsIGNsb3VkcywgYW5kIHlvdSB3aWxsIGtub3csIHRvbywgd2hlbiB5b3UgbGlmdCB
#!                                5b3Vyc2VsZiBoaWdoIGVub3VnaCB0byBzZWUgYmV5b25kIGhvcml6b25zLiINCg0KLVJpY2hhcmQgQmFjaA=="}
#! @input network_id: optional - ID of network to connect to - Default: ''
#! @output error_message: return_result if statusCode is not '202'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by operation
#! @result SUCCESS
#! @result GET_AUTHENTICATION_TOKEN_FAILURE
#! @result GET_TENANT_ID_FAILURE
#! @result ADD_NAME_FAILURE
#! @result ADD_IMG_REF_FAILURE
#! @result ADD_FLAVOR_REF_FAILURE
#! @result ADD_KEY_NAME_FAILURE
#! @result ADD_SECURITY_GROUPS_FAILURE
#! @result ADD_USER_DATA_FAILURE
#! @result ADD_AVAILABILITY_ZONE_FAILURE
#! @result ADD_NETWORK_FAILURE
#! @result ADD_METADATA_FAILURE
#! @result ADD_PERSONALITY_FAILURE
#! @result ADD_INSTANCE_SOURCE_BOOT_FAILURE
#! @result ADD_SERVER_OBJECT_JSON_FAILURE
#! @result CREATE_SERVER_FAILURE
#!!#
####################################################

namespace: io.cloudslang.cloud.openstack.servers

imports:
  json: io.cloudslang.base.json
  strings: io.cloudslang.base.strings
  rest: io.cloudslang.base.http
  openstack: io.cloudslang.cloud.openstack
  utils: io.cloudslang.cloud.openstack.utils

flow:
  name: create_server_flow
  inputs:
    - host
    - identity_port: '5000'
    - compute_port: '8774'
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_keystore:
        default: ${get_sp('io.cloudslang.cloud.openstack.trust_keystore')}
        required: false
    - trust_password:
        default: ${get_sp('io.cloudslang.cloud.openstack.trust_password')}
        required: false
        sensitive: true
    - keystore:
        default: ${get_sp('io.cloudslang.cloud.openstack.keystore')}
        required: false
    - keystore_password:
        default: ${get_sp('io.cloudslang.cloud.openstack.keystore_password')}
        required: false
        sensitive: true
    - tenant_name
    - version: '2'
    - server_name
    - img_ref
    - flavor_ref: '42'
    - boot_index: '0'
    - uuid
    - source_type: ''
    - delete_on_termination: True
    - network_id:
        default: ''
        required: false
    - availability_zone:
        default: 'nova'
        required: false
    - admin_pass:
        default: ''
        required: false
        sensitive: true
    - key_name:
        required: false
    - user_data:
        default: ''
        required: false
    - metadata:
        default: ''
        required: false
    - security_groups:
        default: >
            {"name": "default"}
        required: false
    - personality:
        default: ''
        required: false

  workflow:
    - authentication:
        do:
          openstack.get_authentication_flow:
            - host
            - identity_port
            - username
            - password
            - tenant_name
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - return_result
          - error_message
          - token
          - tenant_id
        navigate:
          - SUCCESS: add_name
          - GET_AUTHENTICATION_FAILURE: GET_AUTHENTICATION_FAILURE
          - GET_AUTHENTICATION_TOKEN_FAILURE: GET_AUTHENTICATION_TOKEN_FAILURE
          - GET_TENANT_ID_FAILURE: GET_TENANT_ID_FAILURE

    - add_name:
        do:
          json.add_value:
            - json_input: >
                {"server": {"security_groups": [], "networks": [], "block_device_mapping_v2": [], "personality": []}}
            - json_path: ['server', 'name']
            - value: ${server_name}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_img_ref
          - FAILURE: ADD_NAME_FAILURE

    - add_img_ref:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['server', 'imageRef']
            - value: ${img_ref}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: add_flavor_ref
          - FAILURE: ADD_IMG_REF_FAILURE

    - add_flavor_ref:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['server', 'flavorRef']
            - value: ${flavor_ref}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: create_boot_json
          - FAILURE: ADD_FLAVOR_REF_FAILURE

    - create_boot_json:
        do:
          utils.create_boot_json:
            - boot_index
            - uuid
            - source_type
            - delete_on_termination
        publish:
          - boot_json
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: update_body_json_with_boot_json
          - ADD_BOOT_INDEX_FAILURE: ADD_BOOT_INDEX_FAILURE
          - ADD_UUID_FAILURE: ADD_UUID_FAILURE
          - ADD_SOURCE_TYPE_FAILURE: ADD_SOURCE_TYPE_FAILURE
          - ADD_DELETE_ON_TERMINATION_FAILURE: ADD_DELETE_ON_TERMINATION_FAILURE

    - update_body_json_with_boot_json:
        do:
          utils.update_list:
            - json_object: ${body_json}
            - list_label: 'block_device_mapping_v2'
            - value: ${boot_json}
        publish:
          - body_json: ${json_output}
          - return_result
          - return_code
          - error_message
        navigate:
          - SUCCESS: add_availability_zone
          - FAILURE: ADD_BLOCK_DEVICE_MAPPING_FAILURE

    - add_availability_zone:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['server', 'availability_zone']
            - value: ${availability_zone}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_key_name
          - FAILURE: ADD_AVAILABILITY_ZONE_FAILURE

    - validate_key_name:
        do:
          strings.string_equals:
            - first_string: ${key_name}
            - second_string: ''
        navigate:
          - SUCCESS: validate_admin_pass
          - FAILURE: add_key_name

    - add_key_name:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['server', 'key_name']
            - value: ${key_name}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_admin_pass
          - FAILURE: ADD_KEY_NAME_FAILURE

    - validate_admin_pass:
        do:
          strings.string_equals:
            - first_string: ${admin_pass}
            - second_string: ''
        navigate:
          - SUCCESS: validate_user_data
          - FAILURE: add_admin_pass

    - add_admin_pass:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['server', 'adminPass']
            - value: ${admin_pass}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_user_data
          - FAILURE: ADD_ADMIN_PASS_FAILURE

    - validate_user_data:
        do:
          strings.string_equals:
            - first_string: ${user_data}
            - second_string: ''
        navigate:
          - SUCCESS: validate_metadata_input
          - FAILURE: add_user_data

    - add_user_data:
        do:
          json.add_value:
            - json_input: ${body_json}
            - json_path: ['server', 'user_data']
            - value: ${user_data}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_metadata_input
          - FAILURE: ADD_USER_DATA_FAILURE

    - validate_metadata_input:
        do:
          strings.string_equals:
            - first_string: ${metadata}
            - second_string: ''
        navigate:
          - SUCCESS: validate_security_groups
          - FAILURE: add_metadata

    - add_metadata:
        do:
          json.add_entry_in_object:
            - json_object: ${body_json}
            - key: 'metadata'
            - value: ${metadata}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_security_groups
          - FAILURE: ADD_METADATA_FAILURE

    - validate_security_groups:
        do:
          strings.string_equals:
            - first_string: ${security_groups}
            - second_string: ''
        navigate:
          - SUCCESS: add_default_security_groups
          - FAILURE: add_security_groups

    - add_default_security_groups:
        do:
          utils.update_list:
            - json_object: ${body_json}
            - list_label: 'security_groups'
            - value: >
                {"name": "default"}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_personality
          - FAILURE: ADD_DEFAULT_SECURITY_GROUP_FAILURE

    - add_security_groups:
        do:
          utils.update_list:
            - json_object: ${body_json}
            - list_label: 'security_groups'
            - value: ${security_groups}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_personality
          - FAILURE: ADD_SECURITY_GROUPS_FAILURE

    - validate_personality:
        do:
          strings.string_equals:
            - first_string: ${personality}
            - second_string: ''
        navigate:
          - SUCCESS: validate_network_id_input
          - FAILURE: add_personality

    - add_personality:
        do:
          utils.update_list:
            - json_object: ${body_json}
            - list_label: 'personality'
            - value: ${personality}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: validate_network_id_input
          - FAILURE: ADD_PERSONALITY_FAILURE

    - validate_network_id_input:
        do:
          strings.string_equals:
            - first_string: ${network_id}
            - second_string: ''
        navigate:
          - SUCCESS: create_server
          - FAILURE: add_network

    - add_network:
        do:
          utils.update_list:
            - json_object: ${body_json}
            - list_label: 'networks'
            - value: >
                ${'{"uuid": "' + network_id + '"}'}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: create_server
          - FAILURE: ADD_NETWORK_FAILURE

    - create_server:
        do:
          rest.http_client_post:
            - url: ${'http://' + host + ':' + compute_port + '/v' + version + '/' + tenant_id + '/servers'}
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - headers: ${'X-AUTH-TOKEN:' + token}
            - body: ${body_json}
            - content_type: 'application/json'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CREATE_SERVER_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - GET_AUTHENTICATION_FAILURE
    - GET_AUTHENTICATION_TOKEN_FAILURE
    - GET_TENANT_ID_FAILURE
    - ADD_NAME_FAILURE
    - ADD_IMG_REF_FAILURE
    - ADD_FLAVOR_REF_FAILURE
    - ADD_AVAILABILITY_ZONE_FAILURE
    - ADD_KEY_NAME_FAILURE
    - ADD_ADMIN_PASS_FAILURE
    - ADD_USER_DATA_FAILURE
    - ADD_NETWORK_FAILURE
    - ADD_METADATA_FAILURE
    - ADD_DEFAULT_SECURITY_GROUP_FAILURE
    - ADD_SECURITY_GROUPS_FAILURE
    - ADD_BOOT_INDEX_FAILURE
    - ADD_UUID_FAILURE
    - ADD_SOURCE_TYPE_FAILURE
    - ADD_DELETE_ON_TERMINATION_FAILURE
    - ADD_BLOCK_DEVICE_MAPPING_FAILURE
    - ADD_PERSONALITY_FAILURE
    - CREATE_SERVER_FAILURE
