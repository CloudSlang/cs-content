#   Copyright 2023 Open Text
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
#! @description: This operation can be used to create disk from a source.
#!
#! @input project_id: The Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input access_token: The authorization token for google cloud.
#! @input zone: The name of the zone in which the instance resides.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input disk_name: Name of the Disk. Provided by the client when the Disk is created. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first character must be a lowercase letter, and all following characters must be a dash, lowercase letter, or digit, except the last character, which cannot be a dash.
#! @input disk_type: Specifies the disk type to use to create the instance. If not specified, the default is pd-standard,
#!                   specified using the full URL. For example:
#!                   https://www.googleapis.com/compute/v1/projects/project/zones/zone/diskTypes/pd-standard
#!                   For a full list of acceptable values, see Persistent disk types. If you specify this field when
#!                   creating a VM, you can provide either the full or partial URL. For example, the following values
#!                   are valid: https://www.googleapis.com/compute/v1/projects/project/zones/zone/diskTypes/diskType
#!                   projects/project/zones/zone/diskTypes/diskType
#!                   zones/zone/diskTypes/diskType
#!                   If you specify this field when creating or updating an instance template or all-instances
#!                   configuration, specify the type of the disk, not the URL. For example: pd-standard.
#!                   Optional
#! @input disk_size: Size of the persistent disk, specified in GB. You can specify this field when creating a persistent disk using the sourceImage or sourceSnapshot parameter, or specify it alone to create an empty persistent disk.If you specify this field along with sourceImage or sourceSnapshot, the value of sizeGb must not be less than the size of the sourceImage or the size of the snapshot.
#!                   Constraint: Number greater or equal with 10
#!                   Default: '500' (considered by API for Empty disk)
#!                   Optional
#! @input disk_description: The description of the new Disk.
#!                          Optional
#! @input source_snapshot: The source snapshot used to create this disk. You can provide this as a partial or full URL to the resource. For example, the following are valid values:
#!                         https://www.googleapis.com/compute/v1/projects/project/global/snapshots/snapshot
#!                         projects/project/global/snapshots/snapshot
#!                         global/snapshots/snapshot
#!                         Optional
#! @input source_snapshot_encryption_key: The customer-supplied encryption key of the source snapshot.
#!                                        Required if the source snapshot is protected by a customer-supplied encryption key.
#!                                        Optional
#! @input source_image: Source image to restore onto a disk.
#!                      Optional
#! @input image_encryption_key: The customer-supplied encryption key of the source image.
#!                              Required if the source image is protected by a customer-supplied encryption key.
#!                              Optional
#! @input licenses_list: A list of publicly visible licenses separated by comma(,). Reserved for Google's use.
#!                       Optional
#! @input source_disk: The source disk used to create this disk. You can provide this as a partial or full URL to the resource. For example, the following are valid values:
#!                     https://www.googleapis.com/compute/v1/projects/project/zones/zone/disks/disk
#!                     https://www.googleapis.com/compute/v1/projects/project/regions/region/disks/disk
#!                     projects/project/zones/zone/disks/disk
#!                     projects/project/regions/region/disks/disk
#!                     zones/zone/disks/disk
#!                     regions/region/disks/disk
#!                     Optional
#! @input disk_encryption_key: Specifies a 256-bit customer-supplied encryption key, encoded in RFC 4648 base64 to either
#!                             encrypt or decrypt this resource. For example: "rawKey": "SGVsbG8gZnJvbSBHb29nbGUgQ2xvdWQgUGxhdGZvcm0="
#!                             Optional
#! @input label_keys: The labels key list separated by comma(,).
#!                    Optional
#! @input label_values: The labels value list separated by comma(,).
#!                      Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in
#!                                 the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: '..JAVA_HOME/java/lib/security/cacerts'
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#!
#! @output disk_json: A JSON containing the disk information.
#! @output return_result: This will contain the response message.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#!
#! @result SUCCESS: The request for the disk to create successfully sent.
#! @result FAILURE: An error occurred while trying to send the request.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2.disks
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: insert_disk
  inputs:
    - project_id:
        sensitive: true
    - access_token:
        sensitive: true
    - zone
    - disk_name
    - disk_type:
        required: false
    - disk_size:
        required: false
    - disk_description:
        required: false
    - source_snapshot:
        required: false
    - source_snapshot_encryption_key:
        required: false
    - source_image:
        required: false
    - image_encryption_key:
        required: false
    - licenses_list:
        required: false
    - source_disk:
        required: false
    - disk_encryption_key:
        required: false
    - label_keys:
        required: false
    - label_values:
        required: false
    - worker_group:
        default: RAS_Operator_Path
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
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
  workflow:
    - create_request_body:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute_v2.disks.utils.create_insert_disk_request_body:
            - disk_description: '${disk_description}'
            - disk_size: '${disk_size}'
            - disk_type: '${disk_type}'
            - disk_name: '${disk_name}'
            - label_keys: '${label_keys}'
            - label_values: '${label_values}'
            - source_snapshot: '${source_snapshot}'
            - source_snapshot_encryption_key: '${source_snapshot_encryption_key}'
            - source_image: '${source_image}'
            - image_encryption_key: '${image_encryption_key}'
            - licenses_list: '${licenses_list}'
            - source_disk: '${source_disk}'
            - disk_encryption_key: '${disk_encryption_key}'
        publish:
          - insert_disk_request_body: '${return_result}'
        navigate:
          - SUCCESS: validate_json
    - api_call_to_insert_the_disk:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://compute.googleapis.com/compute/v1/projects/'+project_id+'/zones/'+zone+'/disks'}"
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - request_character_set: UTF-8
            - headers: "${'Authorization: '+access_token}"
            - query_params: null
            - body: '${insert_disk_request_body}'
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result
          - error_message
          - status_code
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: on_failure
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: "${'The disk '+disk_name+' is created successfully.'}"
            - disk_json: '${return_result}'
        publish:
          - return_result: '${message}'
          - disk_json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - validate_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.validate_json:
            - json_input: '${insert_disk_request_body}'
        publish:
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: api_call_to_insert_the_disk
          - FAILURE: on_failure
  outputs:
    - disk_json
    - return_result
    - status_code
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_request_body:
        x: 80
        'y': 120
      api_call_to_insert_the_disk:
        x: 400
        'y': 120
      set_success_message:
        x: 560
        'y': 120
        navigate:
          5b2f36b4-9be2-4b4f-2ea4-5c767cb0f885:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
      validate_json:
        x: 240
        'y': 120
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 720
          'y': 120
