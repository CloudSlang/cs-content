#   (c) Copyright 2023 Open Text
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
#! @description: This operation is used to form the request body of the insert instance based on the provided inputs.
#!
#! @input instance_name: The name of the resource, provided by the client when initially creating the resource. The
#!                       resource name must be 1-63 characters long, and comply with RFC1035. Specifically, the name
#!                       must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which
#!                       means the first character must be a lowercase letter, and all following characters must be a
#!                       dash, lowercase letter, or digit, except the last character, which cannot be a dash.
#! @input machine_type: Full or partial URL of the machine type resource to use for this instance,
#!                      in the format: zones/zone/machineTypes/machine-type. This is provided by the client when the
#!                      instance is created. For example, the following is a valid partial url to a predefined
#!                      machine type: zones/us-central1-f/machineTypes/n1-standard-1
#!                      To create a custom machine type, provide a URL to a machine type in the following format, where
#!                      CPUS is 1 or an even number up to 32 (2, 4, 6, ... 24, etc), and MEMORY is the total memory for
#!                      this instance. Memory must be a multiple of 256 MB and must be supplied in MB (e.g. 5 GB of memory is 5120 MB):
#!                      zones/zone/machineTypes/custom-CPUS-MEMORY
#!                      For example: zones/us-central1-f/machineTypes/custom-4-5120 For a full list of restrictions,
#!                      read the Specifications for custom machine types.
#! @input network: The URL of the VPC network resource for this instance. When creating an instance, if neither the
#!                 network nor the subnetwork is specified, the default network global/networks/default is used. If the
#!                 selected project doesn't have the default network, you must specify a network or subnet. If the
#!                 network is not specified but the subnetwork is specified, the network is inferred.If you specify this
#!                 property, you can specify the network as a full or partial URL. For example, the following are all
#!                 valid URLs:https://www.googleapis.com/compute/v1/projects/project/global/networks/networkprojects/project/global/networks/networkglobal/networks/default
#! @input subnetwork: The URL of the Subnetwork resource for this instance. If the network resource is in legacy mode,
#!                    do not specify this field. If the network is in auto subnet mode, specifying the subnetwork is
#!                    optional. If the network is in custom subnet mode, specifying the subnetwork is required. If you
#!                    specify this field, you can specify the subnetwork as a full or partial URL. For example, the
#!                    following are all valid URLs: https://www.googleapis.com/compute/v1/projects/project/regions/region/subnetworks/subnetwork
#!                    regions/region/subnetworks/subnetwork
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
#!
#! @output return_result: The insert instance request body.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#!
#! @result SUCCESS: The request body formed successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2.instances.subflows
operation:
  name: insert_instance_request_body
  inputs:
    - instance_name
    - machine_type
    - network
    - subnetwork
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
        required: false
    - disk_device_name:
        required: false
    - disk_attachment_mode:
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
  python_action:
    use_jython: false
    script: "# do not remove the execute function\r\nimport json\r\ndef execute(machine_type,instance_name,instance_description,can_ip_forward,tags_list,label_keys,label_values,metadata_keys,metadata_values,\r\nnetwork,subnetwork,access_config_name,access_config_network_tier,scheduling_preemptible,\r\nservice_account_email,service_account_scopes,auto_delete,is_boot_disk,disk_attachment_mode,disk_device_name,existing_disk_path,\r\ndisk_source_image,disk_name,disk_description,disk_type,disk_size,licenses_list):\r\n    return_code = 0\r\n    return_result = '\"name\": \"'+instance_name+'\",\"machineType\": \"'+machine_type+'\"'\r\n    networkInterfaces = ',\"networkInterfaces\": [{\"network\": \"'+network+'\",\"subnetwork\": \"'+subnetwork+'\"'\r\n    \r\n    if instance_description != '':\r\n        return_result = return_result + ',\"description\": \"'+instance_description+'\"'\r\n    if can_ip_forward != '':\r\n        return_result = return_result + ',\"canIpForward\": \"'+can_ip_forward+'\"'\r\n    if access_config_name != '' or access_config_network_tier != '' :\r\n        return_result = return_result + networkInterfaces\r\n        if access_config_name != '':\r\n            return_result = return_result + ',\"accessConfigs\": [{\"type\":\"ONE_TO_ONE_NAT\",\"name\": \"'+ access_config_name + '\"'\r\n            if access_config_network_tier != '':\r\n                return_result = return_result + ',\"networkTier\": \"'+ access_config_network_tier + '\"}]}]'\r\n            else : return_result = return_result + '}]}]'\r\n        elif access_config_network_tier != '':\r\n            return_result = return_result + ',\"accessConfigs\": [{\"type\":\"ONE_TO_ONE_NAT\",\"networkTier\": \"'+ access_config_network_tier + '\"'\r\n            if access_config_name != '':\r\n                return_result = return_result + ',\"name\": \"'+ access_config_name + '\"}]}]'\r\n            else : return_result = return_result + '}]}]'\r\n    else : return_result = return_result + networkInterfaces +'}]'\r\n    if tags_list != '':\r\n        tags = tags_list.split(',')\r\n        return_result = return_result + ',\"tags\": {\"items\": '+json.dumps(tags)+'}'\r\n    if label_keys != '':\r\n        label_key=label_keys.split(',')\r\n        label_value=label_values.split(',')\r\n        return_result = return_result+',\"labels\": '+json.dumps(dict(zip(label_key,label_value)))\r\n    if metadata_keys != '' and metadata_values != '':\r\n        jsonList = []\r\n        metadata_key = metadata_keys.split(',')\r\n        metadata_value = metadata_values.split(',')     \r\n        for i in range(0,len(metadata_key)):\r\n           jsonList.append({\"key\" : metadata_key[i], \"value\" : metadata_value[i]})\r\n        return_result = return_result + ',\"metadata\": { \"items\": ' + json.dumps(jsonList) + '}'  \r\n    if scheduling_preemptible != '':\r\n        return_result = return_result + ',\"scheduling\": { \"preemptible\" : \"'+ scheduling_preemptible +'\"}'\r\n    if service_account_email != '':\r\n        return_result = return_result + ',\"serviceAccounts\": [{\"email\": \"'+ service_account_email +'\"'\r\n        if service_account_scopes != '':\r\n            scopes = service_account_scopes.split(',')\r\n            return_result = return_result + ',\"scopes\":'+ json.dumps(scopes) + '}]'\r\n        else : return_result = return_result + '}]'\r\n    if existing_disk_path != '' or disk_source_image != '':\r\n        if disk_attachment_mode != '':\r\n            return_result = return_result + ',\"disks\":[ {\"mode\": \"'+disk_attachment_mode+'\"'\r\n            if auto_delete != '':\r\n                return_result = return_result + ',\"autoDelete\": ' + auto_delete\r\n            if is_boot_disk != '':\r\n                return_result = return_result + ',\"boot\": ' + is_boot_disk\r\n            if disk_device_name != '':\r\n                return_result = return_result + ',\"deviceName\": \"' + disk_device_name +'\"'\r\n        if existing_disk_path != '':\r\n            return_result = return_result + ',\"source\": \"' + existing_disk_path + '\"}]'\r\n        if disk_source_image != '':\r\n            return_result = return_result + ',\"initializeParams\": { \"sourceImage\": \"' + disk_source_image + '\"'\r\n            if disk_description != '':\r\n                return_result = return_result + ',\"description\": \"' + disk_description + '\"'\r\n            if disk_type != '':\r\n                return_result = return_result + ',\"diskType\": \"' + disk_type + '\"'\r\n            if disk_size != '':\r\n                return_result = return_result + ',\"diskSizeGb\": \"' + disk_size + '\"'\r\n            if licenses_list != '':\r\n                license = licenses_list.split(',')\r\n                return_result = return_result + ',\"licenses\": ' + json.dumps(license)\r\n            if label_keys != '':\r\n                label_key=label_keys.split(',')\r\n                label_value=label_values.split(',')\r\n                return_result = return_result+',\"labels\": '+json.dumps(dict(zip(label_key,label_value)))\r\n            if disk_name != '':\r\n                return_result = return_result + ',\"diskName\": \"' + disk_name + '\"}}]'\r\n            else: return_result = return_result + '}}]'\r\n    return{\"return_code\": return_code, \"return_result\": '{'+return_result+'}'}"
  outputs:
    - return_result
    - return_code
  results:
    - SUCCESS
