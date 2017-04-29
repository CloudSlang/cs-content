#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Generated operation description
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone in which the instance lives.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input access_token: The access token from get_access_token.
#! @input instance_name: The name that the new instance will have
#!                      Example: "instance-1234"
#! @input instance_description: Generated description
#! @input machine_type: Generated description
#! @input list_delimiter: Generated description
#! @input can_ip_forward: Generated description
#! @input metadata_keys: Generated description
#! @input metadata_values: Generated description
#! @input tags_list: Generated description
#! @input volume_mount_type: Generated description
#! @input volume_mount_mode: Generated description
#! @input volume_auto_delete: Generated description
#! @input volume_disk_device_name: Generated description
#! @input volume_disk_name: Generated description
#! @input volume_disk_source_image: Generated description
#! @input volume_disk_type: Generated description
#! @input volume_disk_size: Generated description
#! @input network: Generated description
#! @input sub_network: Generated description
#! @input access_config_name: Generated description
#! @input access_config_type: Generated description
#! @input scheduling_on_host_maintenance: Generated description
#! @input scheduling_automatic_restart: Generated description
#! @input scheduling_preemptible: Generated description
#! @input service_account_email: Generated description
#! @input service_account_scopes: Generated description
#! @input proxy_host: Optional - Proxy server used to access the provider services.
#! @input proxy_port: Optional - Proxy server port used to access the provider services.
#!                    Default: "8080"
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the <proxyUsername> input value.
#! @input pretty_print: Optional - Whether to format the resulting JSON.
#!                      Default: "true"
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
        default: ${get("access_token", "")}
        private: true
        sensitive: true
        required: false
    - project_id:
        private: false
        sensitive: false
        required: true
    - projectId:
        default: ${get("project_id", "")}
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
        default: ${get("instance_name", "")}
        private: true
        sensitive: false
        required: false
    - instance_description:
        private: false
        sensitive: false
        required: false
    - instanceDescription:
        default: ${get("instance_description", "")}
        private: true
        sensitive: false
        required: false
    - machine_type:
        private: false
        sensitive: false
        required: true
    - machineType:
        default: ${get("machine_type", "")}
        private: true
        sensitive: false
        required: false
    - list_delimiter:
        private: false
        sensitive: false
        required: false
    - listDelimiter:
        default: ${get("list_delimiter", "")}
        private: true
        sensitive: false
        required: false
    - can_ip_forward:
        private: false
        sensitive: false
        required: false
    - canIpForward:
        default: ${get("can_ip_forward", "")}
        private: true
        sensitive: false
        required: false
    - metadata_keys:
        private: false
        sensitive: false
        required: false
    - metadataKeys:
        default: ${get("metadata_keys", "")}
        private: true
        sensitive: false
        required: false
    - metadata_values:
        private: false
        sensitive: false
        required: false
    - metadataValues:
        default: ${get("metadata_values", "")}
        private: true
        sensitive: false
        required: false
    - tags_list:
        private: false
        sensitive: false
        required: false
    - tagsList:
        default: ${get("tags_list", "")}
        private: true
        sensitive: false
        required: false
    - volume_mount_type:
        private: false
        sensitive: false
        required: false
    - volumeMountType:
        default: ${get("volume_mount_type", "")}
        private: true
        sensitive: false
        required: false
    - volume_mount_mode:
        private: false
        sensitive: false
        required: false
    - volumeMountMode:
        default: ${get("volume_mount_mode", "")}
        private: true
        sensitive: false
        required: false
    - volume_auto_delete:
        private: false
        sensitive: false
        required: false
    - volumeAutoDelete:
        default: ${get("volume_auto_delete", "")}
        private: true
        sensitive: false
        required: false
    - volume_disk_device_name:
        private: false
        sensitive: false
        required: true
    - volumeDiskDeviceName:
        default: ${get("volume_disk_device_name", "")}
        private: true
        sensitive: false
        required: false
    - volume_disk_name:
        private: false
        sensitive: false
        required: false
    - volumeDiskName:
        default: ${get("volume_disk_name", "")}
        private: true
        sensitive: false
        required: false
    - volume_disk_source_image:
        private: false
        sensitive: false
        required: true
    - volumeDiskSourceImage:
        default: ${get("volume_disk_source_image", "")}
        private: true
        sensitive: false
        required: false
    - volume_disk_type:
        private: false
        sensitive: false
        required: true
    - volumeDiskType:
        default: ${get("volume_disk_type", "")}
        private: true
        sensitive: false
        required: false
    - volume_disk_size:
        private: false
        sensitive: false
        required: true
    - volumeDiskSize:
        default: ${get("volume_disk_size", "")}
        private: true
        sensitive: false
        required: false
    - network:
        private: false
        sensitive: false
        required: true
    - sub_network:
        private: false
        sensitive: false
        required: true
    - subNetwork:
        default: ${get("sub_network", "")}
        private: true
        sensitive: false
        required: false
    - access_config_name:
        private: false
        sensitive: false
        required: true
    - accessConfigName:
        default: ${get("access_config_name", "")}
        private: true
        sensitive: false
        required: false
    - access_config_type:
        private: false
        sensitive: false
        required: true
    - accessConfigType:
        default: ${get("access_config_type", "")}
        private: true
        sensitive: false
        required: false
    - scheduling_on_host_maintenance:
        private: false
        sensitive: false
        required: true
    - schedulingOnHostMaintenance:
        default: ${get("scheduling_on_host_maintenance", "")}
        private: true
        sensitive: false
        required: false
    - scheduling_automatic_restart:
        private: false
        sensitive: false
        required: true
    - schedulingAutomaticRestart:
        default: ${get("scheduling_automatic_restart", "")}
        private: true
        sensitive: false
        required: false
    - scheduling_preemptible:
        private: false
        sensitive: false
        required: true
    - schedulingPreemptible:
        default: ${get("scheduling_preemptible", "")}
        private: true
        sensitive: false
        required: false
    - service_account_email:
        private: false
        sensitive: false
        required: true
    - serviceAccountEmail:
        default: ${get("service_account_email", "")}
        private: true
        sensitive: false
        required: false
    - service_account_scopes:
        private: false
        sensitive: false
        required: true
    - serviceAccountScopes:
        default: ${get("service_account_scopes", "")}
        private: true
        sensitive: false
        required: false
    - proxy_host:
        private: false
        sensitive: false
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        private: true
        sensitive: false
        required: false
    - proxy_port:
        private: false
        sensitive: false
        required: false
    - proxyPort:
        default: ${get("proxy_port", "")}
        private: true
        sensitive: false
        required: false
    - proxy_username:
        private: false
        sensitive: false
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        private: true
        sensitive: false
        required: false
    - proxy_password:
        private: false
        sensitive: true
        required: false
    - proxyPassword:
        default: ${get("proxy_password", "")}
        private: true
        sensitive: true
        required: false
    - pretty_print:
        private: false
        sensitive: false
        required: false
    - prettyPrint:
        default: ${get("pretty_print", "")}
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
