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
#! @description: This operation can be used to update the SKU, encryption, access tier, or tags for a storage account.
#!               It can also be used to add a custom domain name. Only one custom domain is supported per storage account
#!               Note: This call does not change the storage keys for the account. If you want to change storage account keys,
#!               use the regenerate_storage_account_keys operation.
#!               The location and name of the storage account cannot be changed after creation.
#!
#! @input subscription_id: The ID of the Azure Subscription on which the VM should be created.
#! @input resource_group_name: The name of the Azure Resource Group that should be used to create the VM.
#! @input auth_token: Azure authorization Bearer token
#! @input api_version: The API version used to create calls to Azure
#!                     Default: '2015-06-15'
#! @input location: Specifies the supported Azure location where the storage account will be updated.
#!                  This can be different from the location of the resource group.
#! @input storage_account: The name of the storage account in which the OS and Storage disks of the VM should be created.
#! @input encryption: Provides the encryption settings on the account. If left unspecified, the account will be unencrypted.
#!                    Currently the only service is "blob" and the only property is "enabled".
#! @input account_type: Type of account to be created
#!                     One of the following account types (case-sensitive):
#!                     Standard_LRS (Standard Locally-redundant storage)
#!                     Standard_ZRS (Standard Zone-redundant storage)
#!                     Standard_GRS (Standard Geo-redundant storage)
#!                     Standard_RAGRS (Standard Read access geo-redundant storage)
#!                     Premium_LRS (Premium Locally-redundant storage)
#! @input access_tier: Access tier used for billing:
#!                     Hot: For frequently used data. Higher per-GB charges, but lower per-transaction charges.
#!                     Cool: For infrequently used data. Steeply discounted per-GB charges,
#!                           but higher per-transaction charges.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - Username used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all' - Default: 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!
#! @output output: json response with information about the updated storage account
#! @output status_code: 200 if request completed successfully, others in case something went wrong
#! @output error_message: If the storage account could not be updated the error message will be populated with a response,
#!                        empty otherwise
#!
#! @result SUCCESS: Storage account updated successfully.
#! @result FAILURE: There was an error while trying to update the storage account.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.storage

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: update_storage_account

  inputs:
    - subscription_id
    - resource_group_name
    - auth_token
    - api_version:
        required: false
        default: '2015-06-15'
    - location
    - storage_account
    - account_type:
        required: false
        default: 'Standard_RAGRS'
    - encryption:
        required: false
        default: 'true'
    - access_tier:
        required: false
        default: 'Cold'
    - proxy_host:
        required: false
    - proxy_port:
        default: "8080"
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: "false"
        required: false
    - x_509_hostname_verifier:
        default: "strict"
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true

  workflow:
    - update_storage_account:
        do:
          http.http_client_patch:
            - url: >
                ${'https://management.azure.com/subscriptions/' + subscription_id + '/resourceGroups/' +
                resource_group_name + '/providers/Microsoft.Storage/storageAccounts/' + storage_account +
                '?api-version=' + api_version}
            - body: >
                ${'{"properties":{"customDomain":{"name":"' + domain_name +
                '","useSubDomainName":"true"},"encryption":{"services":{"blob":{"enabled":' + encryption +
                '}},"keySource":"Microsoft.Storage"},"accessTier":"' + access_tier +
                '"},"sku":{"name":"' + account_type + '"},}'}
            - headers: "${'Authorization: ' + auth_token}"
            - auth_type: 'anonymous'
            - preemptive_auth: 'true'
            - content_type: 'application/json'
            - request_character_set: 'UTF-8'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
        publish:
          - output: ${return_result}
          - status_code
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
    - error_message

  results:
    - SUCCESS
    - FAILURE

