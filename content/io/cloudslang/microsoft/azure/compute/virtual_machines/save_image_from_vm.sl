#   Copyright 2024 Open Text
#   This program and the accompanying materials
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
#! @description: This operation can be used to save an image that is associated with a generalized virtual machine
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be created.
#! @input api_version: The API version used to create calls to Azure
#! @input auth_type: Optional - authentication type
#!                   Default: "anonymous"
#! @input auth_token: Azure authorization Bearer token
#! @input vhd_prefix: Specifies the prefix in the name of the blobs that will constitute the storage profile of the image
#! @input destination_container_name: Specifies the name of the container inside which the vhds constituting the image will reside
#! @input override_vhds: Specifies if an existing vhd with same prefix inside the destination container is overwritten
#!                       Default: 'true'
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the VM.
#! @input virtual_machine_name: virtual machine name
#! @input connect_timeout: Optional - time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input proxy_host: Optional - proxy server used to access the web site
#! @input proxy_port: Optional - proxy server port
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Default: ''
#! @input x_509_hostname_verifier: Optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#!
#! @output output: Image was successfully saved from the virtual machine.
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#!
#! @result SUCCESS: virtual machine image saved successfully.
#! @result FAILURE: There was an error while trying to save the virtual machine image.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.virtual_machines

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: save_image_from_vm

  inputs:
    - subscription_id
    - auth_token
    - resource_group_name
    - virtual_machine_name
    - vhd_prefix
    - destination_container_name
    - api_version:
        required: false
        default: '2015-06-15'
    - override_vhds:
        required: false
        default: 'true'
    - connect_timeout:
        default: "0"
        required: false
    - socket_timeout:
        default: "0"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - proxy_port:
        default: "8080"
        required: false
    - proxy_host:
        required: false
    - trust_all_roots:
        default: "false"
        required: false
    - x_509_hostname_verifier:
        default: "strict"
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        default: ''
        required: false
        sensitive: true

  workflow:
    - save_image_from_vm:
        do:
          http.http_client_post:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Compute/virtualMachines/' + virtual_machine_name +
                '/capture?api-version=' + api_version}
            - headers: "${'Authorization: '+ auth_token}"
            - body: >
                ${'{"vhdPrefix":"' + vhd_prefix + '","destinationContainerName":"' + destination_container_name +
                '","overwriteVhds":' + override_vhds + '}'}
            - auth_type: 'anonymous'
            - preemptive_auth: 'true'
            - content_type: 'application/json'
            - request_character_set: 'UTF-8'
            - connect_timeout
            - socket_timeout
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - status_code
          - output: ${return_result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: retrieve_error

    - retrieve_error:
        do:
          json.get_value:
            - json_input: ${output}
            - json_path: 'error,message'
        publish:
          - error_message: ${return_result}
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: FAILURE

  outputs:
    - output
    - status_code

  results:
    - SUCCESS
    - FAILURE
