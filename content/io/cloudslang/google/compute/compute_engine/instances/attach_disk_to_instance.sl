########################################################################################################################
#!!
#! @description: This operation creates a disk resource in the specified project using the data included as inputs.
#!
#! @input project_id: Google Cloud project name.
#!                    Example: 'example-project-a'
#! @input zone: The name of the zone in which the instance lives.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'
#! @input access_token: The access token from get_access_token.
#! @input instance_name: The name that the new instance will have.
#!                       Example: 'instance-1234'
#! @input source: A valid partial or full URL to an existing Persistent Disk resource.
#! @input boot: Indicates that this is a boot disk. The virtual machine will use the first
#!              partition of the disk for its root filesystem.
#!              Optional
#! @input mode: The mode in which to attach the disk to the instance.
#!              Valid: 'READ_WRITE', 'READ_ONLY'
#!              Default: 'READ_WRITE'
#!              Optional
#! @input auto_delete: Whether to delete the disk when the instance is deleted.
#!                    Default: 'false'
#!                    Optional
#! @input device_name: Specifies a unique device name of your choice that is reflected into the
#!                     /dev/disk/by-id/google-* tree of a Linux operating system running within the instance.
#!                     This name can be used to reference the device for mounting, resizing, and so on, from
#!                     within the instance.
#!                     Note: If not specified, the server chooses a default device name to apply to this disk,
#!                     in the form persistent-disks-x, where x is a number assigned by Google Compute Engine.
#!                     This field is only applicable for persistent disks.
#!                     Optional
#! @input interface: Specifies the disk interface to use for attaching this disk.
#!                   Note: Persistent disks must always use SCSI and the request will fail if you attempt to
#!                   attach a persistent disk in any other format than SCSI. Local SSDs can use either
#!                   NVME or SCSI.
#!                   Valid: 'SCSI', 'NVME'
#!                   Default: 'SCSI'
#!                   Optional
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input pretty_print: Whether to format the resulting JSON.
#!                      Valid: 'true', 'false'
#!                      Default: 'true'
#!                      Optional
#!
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output return_result: Contains the ZoneOperation resource, as a JSON object.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output zone_operation_name: Contains the ZoneOperation name, if the returnCode is '0', otherwise it is empty.
#!
#! @result SUCCESS: The request to attach the Disk to an Instance was successfully sent.
#! @result FAILURE: An error occurred while trying to send the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.google.compute.compute_engine.instances

operation: 
  name: attach_disk_to_instance
  
  inputs: 
    - access_token:    
        sensitive: true
    - accessToken: 
        default: ${get('access_token', '')}  
        required: false 
        private: true 
        sensitive: true
    - project_id    
    - projectId: 
        default: ${get('project_id', '')}  
        required: false 
        private: true 
    - zone    
    - instance_name    
    - instanceName: 
        default: ${get('instance_name', '')}  
        required: false 
        private: true 
    - source    
    - boot:  
        required: false  
    - mode:
        default: 'READ_WRITE'
        required: false  
    - auto_delete:
        default: 'false'
        required: false  
    - autoDelete: 
        default: ${get('auto_delete', '')}  
        required: false 
        private: true 
    - device_name:  
        required: false  
    - deviceName: 
        default: ${get('device_name', '')}  
        required: false 
        private: true 
    - interface:
        default: 'SCSI'
        required: false  
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
    - pretty_print:
        default: 'true'
        required: false  
    - prettyPrint: 
        default: ${get('pretty_print', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-google:0.2.1'
    class_name: 'io.cloudslang.content.google.actions.compute.compute_engine.instances.InstancesAttachDisk'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get('exception', '')}
    - zone_operation_name: ${zoneOperationName} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
