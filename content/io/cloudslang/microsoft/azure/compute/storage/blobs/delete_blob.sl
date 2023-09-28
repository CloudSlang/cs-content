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
#! @description: Delete a blob from the container that exists in the specified storage account.
#!
#! @input storage_account: Azure The name of the storage account in which the blob will be deleted.
#! @input key: Azure account key
#! @input container_name: The name of the container in which the blob is
#! @input blob_name: The name of the blob you want to delete
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - username used when connecting to the proxy
#! @input proxy_password: Optional - proxy server password associated with the <proxy_username> input value
#!
#! @output output: The container name of the blob that was deleted
#! @output return_code: 0 if request completed successfully, -1 in case something went wrong
#! @output exception: The stacktrace of the operation in case something went wrong
#!
#! @result SUCCESS: Blob deleted successfully.
#! @result FAILURE: There was an error while trying to delete the blob.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.azure.compute.storage.blobs

operation:
  name: delete_blob
  inputs:
    - storage_account
    - storageAccount:
        default: ${get("storage_account", "")}
        required: false
        private: true
    - key:
        sensitive: true
    - container_name
    - containerName:
        default: ${get("container_name", "")}
        required: false
        private: true
    - blob_name
    - blobName:
        default: ${get("blob_name", "")}
        required: false
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true

  java_action:
    gav: 'io.cloudslang.content:cs-azure:0.0.23'
    class_name: io.cloudslang.content.azure.actions.storage.DeleteBlob
    method_name: execute

  outputs:
    - output: ${returnResult}
    - return_code: ${returnCode}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE

