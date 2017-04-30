#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Creates an instance resource in the specified project using the data included as inputs.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone in which the instance lives.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input access_token: The access token from get_access_token.
#! @input instance_name: The name that the new instance will have
#!                      Example: 'instance-1234'
#! @input instance_description: Optional - The description of the new instance
#! @input machine_type: Full or partial URL of the machine type resource to use for this instance, in the format:
#!                      'zones/zone/machineTypes/machine-type'.
#!                      Example: 'zones/us-central1-f/machineTypes/n1-standard-1'
#! @input list_delimiter: Optional - The delimiter to split all the lists from the inputs
#!                        Default: ','
#! @input can_ip_forward: Optional - Boolean that specifies if the instance is allowed to send and receive packets
#!                        with non-matching destination or source IPs. This is required if you plan to use this instance
#!                        to forward routes
#!                        Default: 'true'
#!                        Valid values: 'true', 'false'
#! @input metadata_keys: Optional - The keys for the metadata entry, separated by the <list_delimiter> delimiter.
#!                       Keys must conform to the following regexp: [a-zA-Z0-9-_]+, and be less than 128 bytes in
#!                       length. This is reflected as part of a URL in the metadata server. Additionally,
#!                       to avoid ambiguity, keys must not conflict with any other metadata keys for the project.
#!                       The length of the itemsKeysList must be equal with the length of the itemsValuesList.
#! @input metadata_values: Optional - The values for the metadata entry, separated by the <list_delimiter> delimiter.
#!                         These are free-form strings, and only have meaning as interpreted by the image running in
#!                         the instance. The only restriction placed on values is that their size must be less than
#!                         or equal to 32768 bytes. The length of the
#!                         itemsKeysList must be equal with the length of the itemsValuesList.
#! @input tags_list: Optional - List of tags, separated by the <list_delimiter> delimiter. Tags are used to
#!                   identify valid sources or targets for network firewalls and are specified by the client
#!                   during instance creation. The tags can be later modified by the setTags method. Each tag
#!                   within the list must comply with RFC1035.
#! @input volume_mount_type: Optional - Specifies the type of the disk, either SCRATCH or PERSISTENT.
#!                           Default: 'PERSISTENT'
#! @input volume_mount_mode: Optional - The mode in which to attach this disk, either READ_WRITE or READ_ONLY.
#!                           Default: 'READ_WRITE'
#! @input volume_auto_delete: Optional - Boolean that specifies whether the disk will be auto-deleted when the instance
#!                            is deleted (but not when the disk is detached from the instance).
#!                            Default: 'true'
#!                            Valid values: 'true', 'false'
#! @input volume_disk_device_name: Optional - Specifies a unique device name of your choice that is reflected into the
#!                                 /dev/disk/by-id/google-* tree of a Linux operating system running within the instance.
#!                                 This name can be used to reference the device for mounting, resizing, and so on, from
#!                                 within the instance. If not specified, the server chooses a default device name to apply
#!                                 to this disk, in the form persistent-disks-x, where x is a number assigned by Google
#!                                 Compute Engine. This field is only applicable for persistent disks.
#! @input volume_disk_name: Optional - Specifies the disk name. If not specified, the default is to use the name of
#!                          the instance.
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
#! @input volume_disk_type:  Optional - Specifies the disk type to use to create the instance. If you define this input,
#!                           you can provide either the full or partial URL. For example, the following are valid values:
#!                           Note that for InstanceTemplate, this is the name of the disk type, not URL.
#!                           Default: pd-standard, specified using the full URL
#!                           Valid values: pd-ssd and local-ssd specified using the full/partial URL
#!                           Example: 'https://www.googleapis.com/compute/v1/projects/project/zones/zone/diskTypes/pd-standard',
#!                           'projects/project/zones/zone/diskTypes/diskType/pd-standard',
#!                           'zones/zone/diskTypes/diskType/pd-standard'
#! @input volume_disk_size: Optional - Specifies the size in GB of the disk on which the system will be installed
#!                          Constraint: Number greater or equal with 10
#!                          Default: '10'
#! @input network: Optional - URL of the network resource for this instance. When creating an instance, if neither the
#!                 network nor the subnetwork is specified, the default network global/networks/default is used;
#!                 if the network is not specified but the subnetwork is specified, the network is inferred.
#!                 This field is optional when creating a firewall rule. If not specified when creating a firewall
#!                 rule, the default network global/networks/default is used.
#!                 If you specify this property, you can specify the network as a full or partial URL. For
#!                 example, the following are all valid URLs:   -
#!                 https://www.googleapis.com/compute/v1/projects/project/global/networks/network  -
#!                 projects/project/global/networks/network  - global/networks/default
#! @input subnetwork: Optional - The URL of the Subnetwork resource for this instance. If the network resource is in legacy
#!                    mode, do not provide this property. If the network is in auto subnet mode, providing the
#!                    subnetwork is optional. If the network is in custom subnet mode, then this field should be
#!                    specified. If you specify this property, you can specify the subnetwork as a full or partial
#!                    URL. For example, the following are all valid URLs: -
#!                    https://www.googleapis.com/compute/v1/projects/project/regions/region/subnetworks/subnetwork  -
#!                    regions/region/subnetworks/subnetwork
#! @input access_config_name: Optional - Name of this access configuration. If specified, then the accessConfigType
#!                            will be taken into account, otherwise not.
#! @input access_config_type: Optional - The type of configuration.
#!                            Valid values: 'ONE_TO_ONE_NAT'
#!                            Default: 'ONE_TO_ONE_NAT'
#! @input scheduling_on_host_maintenance: Optional - Defines the maintenance behavior for this instance. For standard instances,
#!                                        the default behavior is MIGRATE. For preemptible instances, the default and only
#!                                        possible behavior is TERMINATE.
#! @input scheduling_automatic_restart: Optional - Boolean specifying whether the instance should be automatically restarted
#!                                      if it is terminated by Compute Engine (not terminated by a user). You can only set
#!                                      the automatic restart option for standard instances. Preemptible instances cannot
#!                                      be automatically restarted.
#!                                      Valid values: 'true', 'false'
#!                                      Default: 'true'
#! @input scheduling_preemptible: Optional - Boolean specifying whether the instance is preemptible.
#!                                Valid values: 'true', 'false'
#!                                Default: 'false'
#! @input service_account_email: Optional - Email address of the service account
#!                               Default: The service account that was used to generate the token
#! @input service_account_scopes: Optional - The list of scopes to be made available for this service account.
#! @input proxy_host: Optional - Proxy server used to access the provider services.
#! @input proxy_port: Optional - Proxy server port used to access the provider services.
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input pretty_print: Optional - Whether to format the resulting JSON.
#!                      Valid values: 'true', 'false'
#!                      Default: 'true'
#!
#! @output return_code: Generated description
#! @output return_result: Generated description
#! @output exception: Generated description
#!
#! @result SUCCESS: Generated description
#! @result FAILURE: Generated description
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.instances
operation:
  name: insert_instance
  inputs:
    - access_token:
        private: false
        sensitive: true
        required: true
    - accessToken:
        default: ${get('access_token', '')}
        private: true
        sensitive: true
        required: false
    - project_id:
        private: false
        sensitive: false
        required: true
    - projectId:
        default: ${get('project_id', '')}
        private: true
        sensitive: false
        required: false
    - zone:
        private: false
        sensitive: false
        required: true
    - instance_name:
        private: false
        sensitive: false
        required: true
    - instanceName:
        default: ${get('instance_name', '')}
        private: true
        sensitive: false
        required: false
    - instance_description:
        private: false
        sensitive: false
        required: false
    - instanceDescription:
        default: ${get('instance_description', '')}
        private: true
        sensitive: false
        required: false
    - machine_type:
        private: false
        sensitive: false
        required: true
    - machineType:
        default: ${get('machine_type', '')}
        private: true
        sensitive: false
        required: false
    - list_delimiter:
        private: false
        sensitive: false
        required: false
    - listDelimiter:
        default: ${get('list_delimiter', '')}
        private: true
        sensitive: false
        required: false
    - can_ip_forward:
        private: false
        sensitive: false
        required: false
    - canIpForward:
        default: ${get('can_ip_forward', '')}
        private: true
        sensitive: false
        required: false
    - metadata_keys:
        private: false
        sensitive: false
        required: false
    - metadataKeys:
        default: ${get('metadata_keys', '')}
        private: true
        sensitive: false
        required: false
    - metadata_values:
        private: false
        sensitive: false
        required: false
    - metadataValues:
        default: ${get('metadata_values', '')}
        private: true
        sensitive: false
        required: false
    - tags_list:
        private: false
        sensitive: false
        required: false
    - tagsList:
        default: ${get('tags_list', '')}
        private: true
        sensitive: false
        required: false
    - volume_mount_type:
        private: false
        sensitive: false
        required: false
    - volumeMountType:
        default: ${get('volume_mount_type', '')}
        private: true
        sensitive: false
        required: false
    - volume_mount_mode:
        private: false
        sensitive: false
        required: false
    - volumeMountMode:
        default: ${get('volume_mount_mode', '')}
        private: true
        sensitive: false
        required: false
    - volume_auto_delete:
        private: false
        sensitive: false
        required: false
    - volumeAutoDelete:
        default: ${get('volume_auto_delete', '')}
        private: true
        sensitive: false
        required: false
    - volume_disk_device_name:
        private: false
        sensitive: false
        required: true
    - volumeDiskDeviceName:
        default: ${get('volume_disk_device_name', '')}
        private: true
        sensitive: false
        required: false
    - volume_disk_name:
        private: false
        sensitive: false
        required: false
    - volumeDiskName:
        default: ${get('volume_disk_name', '')}
        private: true
        sensitive: false
        required: false
    - volume_disk_source_image:
        private: false
        sensitive: false
        required: true
    - volumeDiskSourceImage:
        default: ${get('volume_disk_source_image', '')}
        private: true
        sensitive: false
        required: false
    - volume_disk_type:
        private: false
        sensitive: false
        required: true
    - volumeDiskType:
        default: ${get('volume_disk_type', '')}
        private: true
        sensitive: false
        required: false
    - volume_disk_size:
        private: false
        sensitive: false
        required: true
    - volumeDiskSize:
        default: ${get('volume_disk_size', '')}
        private: true
        sensitive: false
        required: false
    - network:
        private: false
        sensitive: false
        required: true
    - subnetwork:
        private: false
        sensitive: false
        required: false
    - access_config_name:
        private: false
        sensitive: false
        required: true
    - accessConfigName:
        default: ${get('access_config_name', '')}
        private: true
        sensitive: false
        required: false
    - access_config_type:
        private: false
        sensitive: false
        required: true
    - accessConfigType:
        default: ${get('access_config_type', '')}
        private: true
        sensitive: false
        required: false
    - scheduling_on_host_maintenance:
        private: false
        sensitive: false
        required: true
    - schedulingOnHostMaintenance:
        default: ${get('scheduling_on_host_maintenance', '')}
        private: true
        sensitive: false
        required: false
    - scheduling_automatic_restart:
        private: false
        sensitive: false
        required: true
    - schedulingAutomaticRestart:
        default: ${get('scheduling_automatic_restart', '')}
        private: true
        sensitive: false
        required: false
    - scheduling_preemptible:
        private: false
        sensitive: false
        required: true
    - schedulingPreemptible:
        default: ${get('scheduling_preemptible', '')}
        private: true
        sensitive: false
        required: false
    - service_account_email:
        private: false
        sensitive: false
        required: true
    - serviceAccountEmail:
        default: ${get('service_account_email', '')}
        private: true
        sensitive: false
        required: false
    - service_account_scopes:
        private: false
        sensitive: false
        required: true
    - serviceAccountScopes:
        default: ${get('service_account_scopes', '')}
        private: true
        sensitive: false
        required: false
    - proxy_host:
        private: false
        sensitive: false
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        private: true
        sensitive: false
        required: false
    - proxy_port:
        private: false
        sensitive: false
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        private: true
        sensitive: false
        required: false
    - proxy_username:
        private: false
        sensitive: false
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        private: true
        sensitive: false
        required: false
    - proxy_password:
        private: false
        sensitive: true
        required: false
    - proxyPassword:
        default: ${get('proxy_password', '')}
        private: true
        sensitive: true
        required: false
    - pretty_print:
        private: false
        sensitive: false
        required: false
    - prettyPrint:
        default: ${get('pretty_print', '')}
        private: true
        sensitive: false
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-google-cloud:0.0.1'
    method_name: execute
    class_name: io.cloudslang.content.gcloud.actions.compute.instances.InstancesInsert

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
