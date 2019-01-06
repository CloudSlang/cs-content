########################################################################################################################
#!!
#! @description: Checks if a JSON is valid and, optionally, if it is valid against a schema.
#!
#! @input json_object: JSON to validate.
#! @input json_schema: JSON schema to validate against. Can also be a JSON schema, an URL or a file path.
#!                     Optional
#! @input proxy_host: The proxy host for getting the Get request.
#!                    Optional
#! @input proxy_port: The proxy port for getting the Get request.
#!                    Optional
#! @input proxy_username: The username for connecting via proxy.
#!                        Optional
#! @input proxy_password: The password for connecting via proxy.
#!                        Optional
#!
#! @output return_result: JSON was valid or not (optionally, against a JSON schema).
#!                        Same as exception if an exception was thrown during execution.
#! @output return_code: "0" if validation was successful, "-1" otherwise.
#! @output exception: Exception message if an exception was thrown during execution, empty otherwise.
#!
#! @result SUCCESS: JSON is valid (return_code == '0').
#! @result FAILURE: An error has occurred while trying to validate the given JSON object.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.json

operation:
  name: validate_json

  inputs:
    - json_object
    - jsonObject:
        default: ${get('json_object', '')}
        required: false
        private: true
    - json_schema:
        required: false
    - jsonSchema:
        default: ${get('json_schema', '')}
        required: false
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true

  java_action:
    gav: 'io.cloudslang.content:cs-json:0.0.9-SNAPSHOT'
    class_name: 'io.cloudslang.content.json.actions.ValidateJson'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
