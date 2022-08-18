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
#! @description: This operation can be used to creates an instance in the specified project.
#!
#! @input access_token: The authorization token for google cloud.
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone in which the disks lives.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'.
#! @input machine_type: Full or partial URL of the machine type resource to use for this instance, in the format:
#!                      'zones/zone/machineTypes/machine-type'.
#!                      Example: 'zones/us-central1-f/machineTypes/n1-standard-1'.
#! @input instance_name: The name that the new instance will have.
#!                       Example: 'instance-1234'
#! @input network: URL of the network resource for this instance. When creating an instance, if neither the
#!                 network nor the subnetwork is specified, the default network global/networks/default is used;
#!                 if the network is not specified but the subnetwork is specified, the network is inferred.
#!                 This field is optional when creating a firewall rule. If not specified when creating a firewall
#!                 rule, the default network global/networks/default is used.
#!                 If you specify this property, you can specify the network as a full or partial URL. For
#!                 example, the following are all valid URLs:
#!                 - https://www.googleapis.com/compute/v1/projects/project/global/networks/network
#!                 - projects/project/global/networks/network
#!                 - global/networks/default
#! @input subnetwork: The URL of the Subnetwork resource for this instance. If the network resource is in legacy
#!                    mode, do not provide this property. If the network is in auto subnet mode, providing the
#!                    subnetwork is optional. If the network is in custom subnet mode, then this field should be
#!                    specified. If you specify this property, you can specify the subnetwork as a full or partial
#!                    URL. For example, the following are all valid URLs:
#!                    - https://www.googleapis.com/compute/v1/projects/project/regions/region/subnetworks/subnetwork
#!                    - regions/region/subnetworks/subnetwork
#! @input instance_description: The description of the new instance.
#!                              Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input can_ip_forward: Boolean that specifies if the instance is allowed to send and receive packets
#!                        with non-matching destination or source IPs. This is required if you plan to use this instance
#!                        to forward routes
#!                        Valid values: 'true', 'false'
#!                        Default: 'true'
#!                        Optional
#! @input volume_disk_type: Specifies the disk type to use to create the instance. If you define this input,
#!                          you can provide either the full or partial URL. For example, the following are valid values:
#!                          Note that for InstanceTemplate, this is the name of the disk type, not URL.
#!                          Default: pd-standard, specified using the full URL
#!                          Valid values: pd-ssd and local-ssd specified using the full/partial URL
#!                          Example: 'https://www.googleapis.com/compute/v1/projects/project/zones/zone/diskTypes/pd-standard',
#!                          'projects/project/zones/zone/diskTypes/diskType/pd-standard',
#!                          'zones/zone/diskTypes/diskType/pd-standard'
#!                          Optional
#! @input volume_disk_size: Specifies the size in GB of the disk on which the system will be installed
#!                          Constraint: Number greater or equal with 10
#!                          Default: '10'
#!                          Optional
#! @input volume_disk_name: Specifies the disk name. If not specified, the default is to use the name of the instance.
#!                          Optional
#! @input volume_disk_source_image: The source image to create this disk. To create a disk with one of the public operating
#!                                  system images, specify the image by its family name. For example, specify family/debian-8
#!                                  to use the latest Debian 8 image:
#!                                  'projects/debian-cloud/global/images/family/debian-8'
#!                                  Alternatively, use a specific version of a public operating system image:
#!                                  'projects/debian-cloud/global/images/debian-8-jessie-vYYYYMMDD'
#!                                  To create a disk with a private image that you created, specify the image name in the
#!                                  following format:
#!                                  'global/images/my-private-image'
#!                                  You can also specify a private image by its image family, which returns the latest version
#!                                  of the image in that family. Replace the image name with family/family-name:
#!                                  'global/images/family/my-private-family'
#! @input tags_list: List of tags, separated by the <list_delimiter> delimiter. Tags are used to
#!                   identify valid sources or targets for network firewalls and are specified by the client
#!                   during instance creation. The tags can be later modified by the setTags method. Each tag
#!                   within the list must comply with RFC1035.
#!                   Optional
#! @input label_keys: The keys for the metadata entry, separated by the <list_delimiter> delimiter.
#!                       Keys must conform to the following regexp: [a-zA-Z0-9-_]+, and be less than 128 bytes in
#!                       length. This is reflected as part of a URL in the metadata server. Additionally,
#!                       to avoid ambiguity, keys must not conflict with any other metadata keys for the project.
#!                       The length of the itemsKeysList must be equal with the length of the itemsValuesList.
#!                       Optional
#! @input label_values: The values for the metadata entry, separated by the <list_delimiter> delimiter.
#!                         These are free-form strings, and only have meaning as interpreted by the image running in
#!                         the instance. The only restriction placed on values is that their size must be less than
#!                         or equal to 32768 bytes. The length of the
#!                         itemsKeysList must be equal with the length of the itemsValuesList.
#!                         Optional
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
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#!
#! @result SUCCESS: The request for the Instance to start was successfully sent.
#! @result FAILURE: An error occurred while trying to send the request.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2.instances
imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json
flow:
  name: create_instance
  inputs:
    - project_id:
        sensitive: true
    - access_token:
        sensitive: true
    - zone:
        required: true
    - machine_type:
        required: true
    - instance_name:
        required: true
    - network:
        required: true
    - subnetwork:
        required: true
    - instance_description:
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - can_ip_forward:
        default: 'true'
        required: false
    - volume_disk_type:
        default: PERSISTENT
        required: false
    - volume_disk_size:
        default: '10'
        required: false
    - volume_disk_name:
        required: false
    - volume_disk_source_image:
        required: true
    - tags_list:
        required: false
    - label_keys:
        private: false
        required: false
    - label_values:
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
    - get_label_and_tags:
        do:
          io.cloudslang.google.compute_v2.instances.subflows.get_labels:
            - tags_list: '${tags_list}'
            - label_key: '${label_keys}'
            - label_value: '${label_values}'
        publish:
          - tags_json: '${tagsJson}'
          - label_json: '${labelJson}'
        navigate:
          - SUCCESS: api_call_to_create_the_instance
    - api_call_to_create_the_instance:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://compute.googleapis.com/compute/v1/projects/'+project_id+'/zones/'+zone+'/instances'}"
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
            - body: "${'{\"machineType\": \"'+machine_type+'\",\"name\": \"'+instance_name+'\",\"networkInterfaces\": [{\"network\": \"'+network+'\",\"subnetwork\": \"'+subnetwork+'\"}],\"disks\": [{\"autoDelete\": false,\"boot\": true,\"deviceName\": \"'+volume_disk_name+'\",\"diskSizeGb\": '+volume_disk_size+',\"mode\": \"READ_ONLY\",\"type\": \"'+volume_disk_type+'\", \"source\": \"'+volume_disk_source_image+'\"}],\"canIpForward\": '+can_ip_forward+',\"description\": \"'+instance_description+'\",'+tags_json+''+label_json+'}'}"
            - content_type: application/json
            - worker_group: '${worker_group}'
            - instance_description: null
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
            - message: "${'The instance '+ instance_name+' created successfully.'}"
        publish:
          - return_result: '${message}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_label_and_tags:
        x: 240
        'y': 200
      api_call_to_create_the_instance:
        x: 440
        'y': 200
      set_success_message:
        x: 640
        'y': 200
        navigate:
          5b2f36b4-9be2-4b4f-2ea4-5c767cb0f885:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 800
          'y': 200

