########################################################################################################################
#!!
#! @description: Retrieves a list of all attributes of a given object.
#!
#! @input cmdb_host: The host running UCMDB.
#! @input cmdb_port: The UCMDB server port.
#! @input protocol: The protocol used to connect to the UCMDB server. HTTPS (TLS) is supported only by UCMDB version 9.x and 10.x.
#! @input username: The user name used for the UCMDB server connection.
#! @input password: The password associated with the <username> input value.
#! @input object_id: The identifier of the object to query.
#! @input object_type: The type of the object to query.
#! @input attribute_list: A comma delimited list of attributes to retrieve.
#! @input cmdb_version: The major version number of the UCMDB server.
#! @input keystore: The path to the KeyStore file. This file should contain a certificate the client is capable of authenticating with on the uCMDB server.
#! @input keystore_password: The password associated with the keystore file.
#!
#! @output atributes: The attributes and their values.
#!
#! @result FAILURE: The operation completed unsuccessfully.
#! @result SUCCESS: The operation completed as stated in the description.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.ucmdb
flow:
  name: get_object_attributes_by_id
  inputs:
    - cmdb_host
    - cmdb_port
    - protocol:
        default: http
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - object_id
    - object_type
    - attribute_list:
        required: false
    - cmdb_version:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        required: false
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - trust_keystore:
        required: false
    - trust_password:
        required: false
  workflow:
    - authenticate:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${protocol + '://' + cmdb_host + ':' + cmdb_port + '/rest-api/authenticate'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - source_file: null
            - body: "${'{\"username\": \"' + username + '\", \"password\": \"' + password + '\", \"clientContext\": 1 }'}"
            - content_type: application/json
            - method: POST
        publish:
          - json_token: '${return_result}'
        navigate:
          - SUCCESS: get_value
          - FAILURE: FAILURE
    - get_value:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${json_token}'
            - json_path: token
        publish:
          - token: '${return_result}'
        navigate:
          - SUCCESS: get_ci
          - FAILURE: FAILURE
    - get_ci:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${protocol + '://' + cmdb_host + ':' + cmdb_port + '/rest-api/dataModel/ci/' + object_id}"
            - auth_type: anonymous
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${keystore_password}'
                sensitive: true
            - keystore: '${keystore}'
            - keystore_password:
                value: '${keystore_password}'
                sensitive: true
            - headers: "${'Authorization: Bearer ' + token}"
            - content_type: application/json
            - method: GET
        publish:
          - ci_output: '${return_result}'
        navigate:
          - SUCCESS: get_properties
          - FAILURE: FAILURE
    - get_properties:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${ci_output}'
            - json_path: properties
        publish:
          - ci_output: '${return_result}'
        navigate:
          - SUCCESS: parse_attribute_list
          - FAILURE: FAILURE
    - parse_attribute_list:
        do:
          io.cloudslang.microfocus.ucmdb.utility.parse_attribute_list:
            - attribute_list: '${attribute_list}'
            - json: '${ci_output}'
        publish:
          - attributes: '${attributes_list}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  outputs:
    - return_result
    - return_code
    - exception
    - atributes
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      authenticate:
        x: 40
        y: 126
        navigate:
          343b2945-5ecc-c12c-055a-a942d028d294:
            targetId: 58bcba2e-dac0-8b9d-0b56-157900c2f12d
            port: FAILURE
      get_value:
        x: 203
        y: 128
        navigate:
          89850a21-4c6f-cb95-12a9-a81090455e6a:
            targetId: 58bcba2e-dac0-8b9d-0b56-157900c2f12d
            port: FAILURE
      get_ci:
        x: 362
        y: 127
        navigate:
          189844a8-4892-7cc7-26ba-dc6b19f59efa:
            targetId: 58bcba2e-dac0-8b9d-0b56-157900c2f12d
            port: FAILURE
      get_properties:
        x: 522
        y: 127
        navigate:
          df82a75d-ec0d-e8c2-e5fc-4ffd2d86adb2:
            targetId: 58bcba2e-dac0-8b9d-0b56-157900c2f12d
            port: FAILURE
      parse_attribute_list:
        x: 706
        y: 128
        navigate:
          f83ea97d-1f1d-64aa-a36b-0465827f6696:
            targetId: ec4d30fa-0afc-f2cc-bc04-efccfea82d5a
            port: SUCCESS
          cd3ec36f-44c2-8c8f-536c-900a9fe253a8:
            targetId: 58bcba2e-dac0-8b9d-0b56-157900c2f12d
            port: FAILURE
    results:
      FAILURE:
        58bcba2e-dac0-8b9d-0b56-157900c2f12d:
          x: 362
          y: 485
      SUCCESS:
        ec4d30fa-0afc-f2cc-bc04-efccfea82d5a:
          x: 963
          y: 130
