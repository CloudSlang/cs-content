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
#! @description: This operation creates an instance in the specified project. The instance can be created using existing
#!               disk and also creating new boot disk while deploying the instance by providing disk image details.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input access_token: The authorization token for google cloud.
#! @input zone: The name of the zone in which the instance resides.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'.
#! @input instance_name: The name of the instance, provided while creating the instance.
#!                       resource name must be 1-63 characters long, and comply with RFC1035. Specifically, the name
#!                       must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which
#!                       means the first character must be a lowercase letter, and all following characters must be a
#!                       dash, lowercase letter, or digit, except the last character, which cannot be a dash.
#!                       Example: 'instance-1234'
#! @input machine_type: Full or partial URL of the machine type resource to use for this instance, in the format:
#!                      'zones/zone/machineTypes/machine-type'.
#!                      Example: 'zones/us-central1-f/machineTypes/n1-standard-1'.
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
#! @input instance_description: An optional description of this resource. Provide this property when you create the resource.
#!                              Optional
#! @input can_ip_forward: Allows this instance to send and receive packets with non-matching destination or source IPs.
#!                        This is required if you plan to use this instance to forward routes. For more information, see Enabling IP Forwarding.
#!                        Optional
#! @input access_config_network_tier: This signifies the networking tier used for configuring this access configuration
#!                                    and can only take the following values: PREMIUM, STANDARD.
#!                                    If an AccessConfig is specified without a valid external IP address, an ephemeral
#!                                    IP will be created with this networkTier. If an AccessConfig with a valid external
#!                                    IP address is specified, it must match that of the networkTier associated with the
#!                                    Address resource owning that IP.
#!                                    Valid Values: 'PREMIUM','STANDARD'.
#!                                    Optional
#! @input access_config_name: The name of this access configuration. The default and recommended name is External NAT,
#!                            but you can use any arbitrary string, such as My external IP or Network Access.
#!                            Optional
#! @input auto_delete: Specifies whether the disk will be auto-deleted when the instance is deleted (but not when the
#!                     disk is detached from the instance).
#!                     Optional
#! @input is_boot_disk: Indicates that this is a boot disk. The virtual machine will use the first partition of the disk
#!                      for its root filesystem.
#!                      Default: 'true'.
#! @input disk_device_name: Specifies a unique device name of your choice that is reflected into the /dev/disk/by-id/google-*
#!                          tree of a Linux operating system running within the instance. This name can be used to
#!                          reference the device for mounting, resizing, and so on, from within the instance.
#!                          If not specified, the server chooses a default device name to apply to this disk,
#!                          in the form persistent-disk-x, where x is a number assigned by Google Compute Engine.
#!                          This field is only applicable for persistent disks.
#!                          Optional
#! @input disk_attachment_mode: The mode in which to attach this disk, either READ_WRITE or READ_ONLY. If not specified,
#!                              the default is to attach the disk in READ_WRITE mode.
#!                              Default: 'READ_WRITE'.
#!                              Valid Values: 'READ_WRITE', 'READ_ONLY'.
#! @input existing_disk_path: Specifies a valid partial or full URL to an existing Persistent Disk resource. When
#!                            creating a new instance, one of initializeParams.sourceImage or initializeParams.sourceSnapshot
#!                            or disks.source is required except for local SSD.
#!                            If desired, you can also attach existing non-root persistent disks using this property.
#!                            This field is only applicable for persistent disks.
#!                            Note that for InstanceTemplate, specify the disk name for zonal disk, and the URL for regional disk.
#! @input disk_source_image: The source image to create this disk. When creating a new instance, one of initializeParams.sourceImage
#!                           or initializeParams.sourceSnapshot or disks.source is required except for local SSD.
#!                           To create a disk with one of the public operating system images, specify the image by its
#!                           family name. For example, specify family/debian-9 to use the latest Debian 9 image:
#!                           projects/debian-cloud/global/images/family/debian-9
#!                           Alternatively, use a specific version of a public operating system image:
#!                           projects/debian-cloud/global/images/debian-9-stretch-vYYYYMMDD
#!                           To create a disk with a custom image that you created, specify the image name in the following format:
#!                           global/images/my-custom-image
#!                           You can also specify a custom image by its image family, which returns the latest version
#!                           of the image in that family. Replace the image name with family/family-name:
#!                           global/images/family/my-image-family
#! @input disk_name: Specifies the disk name. If not specified, the default is to use the name of the instance. If a
#!                   disk with the same name already exists in the given region, the existing disk is attached to the
#!                   new instance and the new disk is not created.
#! @input disk_description: An optional description of this resource. Provide this property when you create the resource.
#! @input disk_size: The size, in GB, of the persistent disk. You can specify this field when creating a persistent disk
#!                   using the sourceImage, sourceSnapshot, or sourceDisk parameter, or specify it alone to create an
#!                   empty persistent disk.If you specify this field along with a source, the value of sizeGb must not
#!                   be less than the size of the source. Acceptable values are 1 to 65536, inclusive.
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
#! @input licenses_list: A list of publicly visible licenses. Reserved for Google's use.
#!                       Optional
#! @input label_keys: The labels key list separated by comma(,).
#!                    Keys must conform to the following regexp: [a-zA-Z0-9-_]+, and be less than 128 bytes in
#!                    length. This is reflected as part of a URL in the metadata server. Additionally,
#!                    to avoid ambiguity, keys must not conflict with any other metadata keys for the project.
#!                    The length of the itemsKeysList must be equal with the length of the itemsValuesList.
#!                    Optional
#! @input label_values: The labels value list separated by comma(,).
#!                      Optional
#! @input service_account_email: The Email address of the service account.
#!                               Optional
#! @input service_account_scopes: The list of scopes to be made available for this service account.
#!                                Optional
#! @input scheduling_preemptible: Defines whether the instance is preemptible. This can only be set during instance
#!                                creation or while the instance is stopped and therefore, in a TERMINATED state. See
#!                                Instance Life Cycle for more information on the possible instance states.
#!                                Optional
#! @input metadata_keys: The list of metadata key inputs separated by comma(,).
#!                       Keys must conform to the following regexp: [a-zA-Z0-9-_]+, and be less than 128 bytes in
#!                       length. This is reflected as part of a URL in the metadata server. Additionally,
#!                       to avoid ambiguity, keys must not conflict with any other metadata keys for the project.
#!                       The length of the itemsKeysList must be equal with the length of the itemsValuesList.
#!                       Optional
#! @input metadata_values: The list of metadata value inputs separated by comma(,).
#!                         These are free-form strings, and only have meaning as interpreted by the image running in
#!                         the instance. The only restriction placed on values is that their size must be less than
#!                         or equal to 32768 bytes. The length of the
#!                         itemsKeysList must be equal with the length of the itemsValuesList.
#!                         Optional
#! @input tags_list: The list of tags to apply to this instance. Tags are used to identify valid sources or targets for
#!                   network firewalls and are specified by the client during instance creation. The tags can be later
#!                   modified by the setTags method. Each tag within the list must comply with RFC1035. Multiple tags
#!                   can be specified via the 'tags.items' field. The values should be separated by comma(,).
#!                   Optional
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
#! @output instance_json: A JSON list containing the Instance information.
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
  name: insert_instance
  inputs:
    - project_id:
        sensitive: true
    - access_token:
        sensitive: true
    - zone:
        required: true
    - instance_name:
        required: true
    - machine_type:
        required: true
    - network:
        required: true
    - subnetwork:
        required: true
    - instance_description:
        required: false
    - can_ip_forward:
        required: false
    - access_config_network_tier:
        required: false
    - access_config_name:
        required: false
    - auto_delete:
        required: false
    - is_boot_disk:
        default: 'true'
        required: false
    - disk_device_name:
        required: false
    - disk_attachment_mode:
        default: READ_WRITE
        required: false
    - existing_disk_path:
        required: false
    - disk_source_image:
        required: false
    - disk_name:
        required: false
    - disk_description:
        required: false
    - disk_size:
        required: false
    - disk_type:
        required: false
    - licenses_list:
        required: false
    - label_keys:
        private: false
        required: false
    - label_values:
        required: false
    - service_account_email:
        required: false
    - service_account_scopes:
        required: false
    - scheduling_preemptible:
        required: false
    - metadata_keys:
        required: false
    - metadata_values:
        required: false
    - tags_list:
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
    - insert_instance_request_body:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.google.compute_v2.instances.subflows.insert_instance_request_body:
            - instance_name: '${instance_name}'
            - machine_type: '${machine_type}'
            - network: '${network}'
            - subnetwork: '${subnetwork}'
            - instance_description: '${instance_description}'
            - can_ip_forward: '${can_ip_forward}'
            - access_config_network_tier: '${access_config_network_tier}'
            - access_config_name: '${access_config_name}'
            - auto_delete: '${auto_delete}'
            - is_boot_disk: '${is_boot_disk}'
            - disk_device_name: '${disk_device_name}'
            - disk_attachment_mode: '${disk_attachment_mode}'
            - existing_disk_path: '${existing_disk_path}'
            - disk_source_image: '${disk_source_image}'
            - disk_name: '${disk_name}'
            - disk_description: '${disk_description}'
            - disk_size: '${disk_size}'
            - disk_type: '${disk_type}'
            - licenses_list: '${licenses_list}'
            - label_keys: '${label_keys}'
            - label_values: '${label_values}'
            - service_account_email: '${service_account_email}'
            - service_account_scopes: '${service_account_scopes}'
            - scheduling_preemptible: '${scheduling_preemptible}'
            - metadata_keys: '${metadata_keys}'
            - metadata_values: '${metadata_values}'
            - tags_list: '${tags_list}'
        publish:
          - insert_instance_request_body: '${return_result}'
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
            - body: '${insert_instance_request_body}'
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
            - message: "${'The instance '+ instance_name+' created successfully.'}"
            - instance_json: '${return_result}'
        publish:
          - return_result: '${message}'
          - instance_json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - instance_json
    - return_result
    - status_code
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      insert_instance_request_body:
        x: 80
        'y': 160
      api_call_to_create_the_instance:
        x: 240
        'y': 160
      set_success_message:
        x: 400
        'y': 160
        navigate:
          5b2f36b4-9be2-4b4f-2ea4-5c767cb0f885:
            targetId: 11a314fb-962f-5299-d0a5-ada1540d2904
            port: SUCCESS
    results:
      SUCCESS:
        11a314fb-962f-5299-d0a5-ada1540d2904:
          x: 560
          'y': 160
