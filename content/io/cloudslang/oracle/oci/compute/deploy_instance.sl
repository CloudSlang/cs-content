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
#! @description: Deploy's a new instance in the specified compartment and the specified availability domain.
#!
#! @input tenancy_ocid: Oracle creates a tenancy for your company, which is a secure and isolated partition where you
#!                      can create, organize, and administer your cloud resources. This is the ID of the tenancy.
#! @input user_ocid: The ID of an individual employee or system that needs to manage or use your company’s Oracle Cloud
#!                   Infrastructure resources.
#! @input finger_print: The finger print of the public key generated for the OCI account.
#! @input private_key_file: The path to the private key file on the machine where the worker is.
#! @input compartment_ocid: Compartments are a fundamental component of the Oracle Cloud Infrastructure for organizing and
#!                          isolating your cloud resources. This is the ID of the compartment.
#! @input availability_domain: The availability domain of the instance.
#! @input subnet_id: The OCID of the subnet in which the VNIC will be created.
#! @input shape: The shape of an instance. The shape determines the number of CPUs, amount of memory, and other
#!               resources allocated to the instance.
#!               Example: VM.Standard2.1,VM.Standard2.2, etc.
#! @input region: The region's name.
#!                Example: ap-sydney-1, ap-melbourne-1, sa-saopaulo-1, etc.
#! @input api_version: Version of the API of OCI.
#!                     Default: '20160918'
#!                     Optional
#! @input display_name: A user-friendly name that does not have to be unique and changeable. Ex: My bare metal instance
#!                      Optional
#! @input hostname_label: The hostname for the VNIC's primary private IP. Used for DNS. The value is the hostname
#!                        portion of the primary private IP's fully qualified domain name.
#!                        Optional
#! @input defined_tags: Defined tags for a resource. Each key is predefined and scoped to a namespace.
#!                      Example: {"Operations": {"CostCenter": "42"}}
#!                      Optional
#! @input freeform_tags: Free-form tags for a resource. Each tag is a simple key-value pair with no predefined name,
#!                       type, or namespace.
#!                       Example: {"Department": "Finance"}
#!                       Optional
#! @input ssh_authorized_keys: Provide one or more public SSH keys  for the default user on the instance. Use a newline
#!                             character to separate multiple keys.
#!                             Optional
#! @input userdata: Provide your own base64-encoded data to be used by Cloud-Init to run custom scripts or provide
#!                  custom Cloud-Init configuration.
#!                  Optional
#! @input dedicated_vm_host_id: The OCID of the dedicated VM host.
#!                              Optional
#! @input extended_metadata: Additional metadata key/value pairs that you provide. They serve the same purpose and
#!                           functionality as fields in the 'metadata' object.
#!                           They are distinguished from 'metadata'
#!                           fields in that these can be nested JSON objects (whereas 'metadata' fields are
#!                           string/string maps only).
#!                           Optional
#! @input fault_domain: A fault domain is a grouping of hardware and infrastructure within an availability domain. Each
#!                      availability domain contains three fault domains. Fault domains let you distribute your
#!                      instances so that they are not on the same physical hardware within a single availability
#!                      domain. A hardware failure or Compute hardware maintenance that affects one fault domain does
#!                      not affect instances in other fault domains.
#!                      If you do not specify the fault domain, the system
#!                      selects one for you.
#!                      Optional
#! @input source_type: The source type for the instance. Use image when specifying the image OCID. Use bootVolume when
#!                     specifying the boot volume OCID.
#! @input image_id: The OCID of the image used to boot the instance. If the sourceType is 'image', then this value is
#!                  required.
#!                  Optional
#! @input boot_volume_size_in_gbs: The size of the boot volume in GBs. Minimum value is 50 GB and maximum value is
#!                                 16384 GB (16TB).
#!                                 Optional
#! @input kms_key_id: The OCID of the Key Management Service key that is assigned as the master encryption key for the boot volume.
#!                    Optional
#! @input boot_volume_id: The OCID of the boot volume used to boot the instance. If the sourceType is 'bootVolume', then
#!                        this value is required.
#!                        Optional
#! @input vnic_display_name: A user-friendly name for the VNIC that does not have to be unique.
#!                           Optional
#! @input assign_public_ip: Whether the VNIC should be assigned a public IP address. Defaults to whether the subnet is
#!                          public or private.
#!                          Optional
#! @input vnic_defined_tags: Defined tags for VNIC. Each key is predefined and scoped to a namespace.
#!                           Example: {"Operations": {"CostCenter": "42"}}
#!                           Optional
#! @input vnic_freeform_tags: Free-form tags for VNIC. Each tag is a simple key-value pair with no predefined name,
#!                            type, or namespace.
#!                            Example: {"Department": "Finance"}
#!                            Optional
#! @input network_security_group_ids: A list of the OCIDs of the network security groups (NSGs) to add the VNIC to.
#!                                    Maximum allowed security groups are 5
#!                                    Example: [nsg1,nsg2]
#!                                    Optional
#! @input private_ip: A private IP address of your choice to assign to the VNIC. Must be an available IP address within
#!                    the subnet's CIDR. If you don't specify a value, Oracle automatically assigns a private IP address
#!                    from the subnet. This is the VNIC's primary private IP address.
#!                    Optional
#! @input skip_source_dest_check: Whether the source/destination check is disabled on the VNIC.
#!                                Default: 'false'
#!                                Optional
#! @input ocpus: The total number of OCPUs available to the instance.
#!               Optional
#! @input launch_mode: Specifies the configuration mode for launching virtual machine (VM) instances. The configuration
#!                     modes are:
#!                     NATIVE - VM instances launch with iSCSI boot and VFIO devices. The default value for
#!                     Oracle-provided images.
#!                     EMULATED - VM instances launch with emulated devices, such as the E1000
#!                     network driver and emulated SCSI disk controller.
#!                     PARAVIRTUALIZED - VM instances launch with
#!                     paravirtualized devices using virtio drivers.
#!                     CUSTOM - VM instances launch with custom
#!                     configuration settings specified in the LaunchOptions parameter.
#!                     Optional
#! @input is_pv_encryption_in_transit_enabled: Whether to enable in-transit encryption for the data volume's
#!                                             paravirtualized attachment.Default: 'false'
#!                                             Optional
#! @input ipxe_script: When a bare metal or virtual machine instance boots, the iPXE firmware that runs on the instance
#!                     is configured to run an iPXE script to continue the boot process.
#!                     If you want more control over
#!                     the boot process, you can provide your own custom iPXE script that will run when the instance
#!                     boots; however, you should be aware that the same iPXE script will run every time an instance
#!                     boots and not only after the initial LaunchInstance call.
#!                     Optional
#! @input boot_volume_type: Emulation type for volume.
#!                          ISCSI - ISCSI attached block storage device.
#!                          SCSI - Emulated SCSI disk.
#!                          IDE - Emulated IDE disk.
#!                          VFIO - Direct attached Virtual Function storage. This is the
#!                          default option for Local data volumes on Oracle provided images.
#!                          PARAVIRTUALIZED -
#!                          Paravirtualized disk. This is the default for Boot Volumes and Remote Block Storage volumes
#!                          on Oracle provided images.
#!                          Optional
#! @input firmware: Firmware used to boot VM. Select the option that matches your operating system.
#!                  BIOS - Boot VM using
#!                  BIOS style firmware. This is compatible with both 32 bit and 64 bit operating systems that boot
#!                  using MBR style bootloaders.
#!                  UEFI_64 - Boot VM using UEFI style firmware compatible with 64 bit
#!                  operating systems. This is the default for Oracle provided images.
#!                  Optional
#! @input is_consistent_volume_naming_enabled: Whether to enable consistent volume naming feature.
#!                                             Default: 'false'
#!                                             Optional
#! @input network_type: Emulation type for the physical network interface card (NIC).
#!                      E1000 - Emulated Gigabit ethernet
#!                      controller. Compatible with Linux e1000 network driver.
#!                      VFIO - Direct attached Virtual Function
#!                      network controller. This is the networking type when you launch an instance using
#!                      hardware-assisted (SR-IOV) networking.
#!                      PARAVIRTUALIZED - VM instances launch with
#!                      paravirtualized devices using virtio drivers.
#!                      Optional
#! @input remote_data_volume_type: Emulation type for volume.
#!                                 ISCSI - ISCSI attached block storage device.
#!                                 SCSI -
#!                                 Emulated SCSI disk.
#!                                 IDE - Emulated IDE disk.
#!                                 VFIO - Direct attached Virtual Function
#!                                 storage. This is the default option for Local data volumes on Oracle provided
#!                                 images.
#!                                 PARAVIRTUALIZED - Paravirtualized disk.This is the default for Boot Volumes
#!                                 and Remote Block Storage volumes on Oracle provided images.
#!                                 Optional
#! @input is_management_disabled: Whether the agent running on the instance can run all the available management
#!                                plugins.
#!                                Default: 'false'
#!                                Optional
#! @input is_monitoring_disabled: Whether the agent running on the instance can gather performance metrics and monitor
#!                                the instance
#!                                Default: 'false'
#!                                Optional
#! @input proxy_host: Proxy server used to access the OCI.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the OCI.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period of inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, an existing open connection is used and the connection will be closed after
#!                    execution.
#!                    Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: '20'
#!                               Optional
#! @input retry_count: Number of checks if the instance was created successfully.
#!                     Default: '30'
#!                     Optional
#! @input get_default_Credentials: Gets the default credentials for the instance. Only works for instances that
#!                                 require a password to log in, such as Windows. If the value is set as 'true', then
#!                                 instance username and password will be sent through an email. Enter all the required
#!                                 details in the email related properties.
#!                                 Default: 'false'
#!                                 Optional
#! @input smtp_server_hostname: The hostname or ip address of the smtp server.
#!                              Optional
#! @input smtp_server_port: The port of the smtp service.
#!                          Optional
#! @input from_email: From email address.
#!                    Optional
#! @input to_email: A delimiter separated list of email address(es) or recipients where the email will be sent.
#!                  Optional
#! @input smtp_server_username: If SMTP authentication is needed, the username to use.
#!                              Default: ''
#!                              Optional
#! @input smtp_server_password: If SMTP authentication is needed, the password to use.
#!                              Default: ''
#!                              Optional
#!
#! @output instance_name: The instance name.
#! @output instance_id: The OCID of the instance.
#! @output instance_state: The current state of the instance.
#! @output vnic_name: Name of the VNIC.
#! @output vnic_id: The OCID of the vnic.
#! @output vnic_state: The current state of the VNIC.
#! @output vnic_hostname: The hostname for the VNIC's primary private IP. Used for DNS.
#! @output private_ip_address: The private IP address of the primary privateIp object on the VNIC. The address is within the
#!                     CIDR of the VNIC's subnet.
#! @output public_ip_address: The public IP address of the VNIC.
#! @output mac_address: The MAC address of the VNIC.
#!
#! @result FAILURE: There was an error while executing the request.
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute
flow:
  name: deploy_instance
  inputs:
    - tenancy_ocid
    - user_ocid
    - finger_print:
        sensitive: true
    - private_key_file
    - compartment_ocid
    - availability_domain
    - subnet_id
    - shape
    - region
    - api_version:
        required: false
    - display_name:
        required: false
    - hostname_label:
        required: false
    - defined_tags:
        required: false
    - freeform_tags:
        required: false
    - ssh_authorized_keys:
        required: false
        sensitive: true
    - userdata:
        required: false
    - dedicated_vm_host_id:
        required: false
    - extended_metadata:
        required: false
    - fault_domain:
        required: false
    - source_type:
        required: false
    - image_id:
        required: false
    - boot_volume_size_in_gbs:
        required: false
    - kms_key_id:
        required: false
    - boot_volume_id:
        required: false
    - vnic_display_name:
        required: false
    - assign_public_ip:
        required: false
    - vnic_defined_tags:
        required: false
    - vnic_freeform_tags:
        required: false
    - network_security_group_ids:
        required: false
    - private_ip:
        required: false
    - skip_source_dest_check:
        required: false
    - ocpus:
        required: false
    - launch_mode:
        required: false
    - is_pv_encryption_in_transit_enabled:
        required: false
    - ipxe_script:
        required: false
    - boot_volume_type:
        required: false
    - firmware:
        required: false
    - is_consistent_volume_naming_enabled:
        required: false
    - network_type:
        required: false
    - remote_data_volume_type:
        required: false
    - is_management_disabled:
        required: false
    - is_monitoring_disabled:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
    - keep_alive:
        required: false
    - connections_max_per_route:
        required: false
    - connections_max_total:
        required: false
    - retry_count:
        default: '30'
        required: false
    - get_default_Credentials:
        default: 'false'
        required: false
    - smtp_server_hostname:
        required: false
    - smtp_server_port:
        required: false
    - from_email:
        required: false
    - to_email:
        required: false
    - smtp_server_username:
        required: false
    - smtp_server_password:
        required: false
        sensitive: true
  workflow:
    - create_instance:
        do:
          io.cloudslang.oracle.oci.compute.instances.create_instance:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file:
                value: '${private_key_file}'
            - api_version: '${api_version}'
            - compartment_ocid: '${compartment_ocid}'
            - region: '${region}'
            - availability_domain: '${availability_domain}'
            - shape: '${shape}'
            - subnet_id: '${subnet_id}'
            - source_type: '${source_type}'
            - boot_volume_size_in_gbs: '${boot_volume_size_in_gbs}'
            - kms_key_id: '${kms_key_id}'
            - boot_volume_id: '${boot_volume_id}'
            - dedicated_vm_host_id: '${dedicated_vm_host_id}'
            - image_id: '${image_id}'
            - defined_tags: '${defined_tags}'
            - freeform_tags: '${freeform_tags}'
            - display_name: '${display_name}'
            - userdata: '${userdata}'
            - extended_metadata: '${extended_metadata}'
            - launch_mode: '${launch_mode}'
            - fault_domain: '${fault_domain}'
            - is_pv_encryption_in_transit_enabled: '${is_pv_encryption_in_transit_enabled}'
            - ipxe_script: '${ipxe_script}'
            - vnic_display_name: '${vnic_display_name}'
            - ssh_authorized_keys:
                value: '${ssh_authorized_keys}'
                sensitive: true
            - assign_public_ip: '${assign_public_ip}'
            - vnic_defined_tags: '${vnic_defined_tags}'
            - vnic_freeform_tags: '${vnic_freeform_tags}'
            - network_security_group_ids: '${network_security_group_ids}'
            - private_ip: '${private_ip}'
            - skip_source_dest_check: '${skip_source_dest_check}'
            - ocpus: '${ocpus}'
            - boot_volume_type: '${boot_volume_type}'
            - firmware: '${firmware}'
            - is_consistent_volume_naming_enabled: '${is_consistent_volume_naming_enabled}'
            - network_type: '${network_type}'
            - remote_data_volume_type: '${remote_data_volume_type}'
            - is_management_disabled: '${is_management_disabled}'
            - is_monitoring_disabled: '${is_monitoring_disabled}'
            - hostname_label: '${hostname_label}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - proxy_port: '${proxy_port}'
        publish:
          - return_result
          - instance_id
          - instance_name
        navigate:
          - SUCCESS: get_instance_details
          - FAILURE: on_failure
    - get_instance_details:
        do:
          io.cloudslang.oracle.oci.compute.instances.get_instance_details:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file:
                value: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - proxy_port: '${proxy_port}'
        publish:
          - instance_state
        navigate:
          - SUCCESS: instance_status
          - FAILURE: on_failure
    - instance_status:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: RUNNING
        navigate:
          - SUCCESS: list_vnic_attachments
          - FAILURE: wait_for_instance_status
    - get_vnic_details:
        do:
          io.cloudslang.oracle.oci.compute.vnics.get_vnic_details:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file:
                value: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - vnic_id: '${vnic_id}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - proxy_port: '${proxy_port}'
        publish:
          - private_ip
          - public_ip
          - vnic_name
          - vnic_hostname
          - vnic_state
          - mac_address
        navigate:
          - SUCCESS: get_default_credentials
          - FAILURE: on_failure
    - list_vnic_attachments:
        do:
          io.cloudslang.oracle.oci.compute.vnics.list_vnic_attachments:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file:
                value: '${private_key_file}'
            - api_version: '${api_version}'
            - compartment_ocid: '${compartment_ocid}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - proxy_host: '${proxy_host}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
            - proxy_port: '${proxy_port}'
        publish:
          - vnic_id: '${vnic_list}'
        navigate:
          - SUCCESS: get_vnic_details
          - FAILURE: on_failure
    - counter:
        do:
          io.cloudslang.oracle.oci.utils.counter:
            - from: '1'
            - to: '${retry_count}'
            - increment_by: '1'
        navigate:
          - HAS_MORE: get_instance_details
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_instance_status:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - get_default_credentials:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${get_default_Credentials}'
            - second_string: 'true'
        publish:
          - default_username: ''
          - default_password: ''
        navigate:
          - SUCCESS: get_instance_default_credentials
          - FAILURE: SUCCESS
    - get_instance_default_credentials:
        do:
          io.cloudslang.oracle.oci.compute.instances.get_instance_default_credentials:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file:
                value: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
        publish:
          - instance_username
          - instance_password
        navigate:
          - SUCCESS: send_instance_credentials_mail
          - FAILURE: on_failure
    - send_instance_credentials_mail:
        do:
          io.cloudslang.base.mail.send_mail:
            - hostname: '${smtp_server_hostname}'
            - port: '${smtp_server_port}'
            - from: '${from_email}'
            - to: '${to_email}'
            - subject: "${'OCI Instance ' + \"'\"+instance_name+\"'\" + ' Credentials'}"
            - body: "${'<p><b>OCI Instance ' +  \"'\"+instance_name+\"'\"  + ' Credentials</b></p><div><b>Instance OCID:</b> '+ instance_id +'</div><div><b>Instance Username:</b> '+ instance_username +'</div><div><b>Instance Password:</b> ' + instance_password + '</div><div><b>Instance Public IP Address:</b> ' + public_ip + '</div>'}"
            - html_email: 'true'
            - username: '${smtp_server_username}'
            - password:
                value: '${smtp_server_password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - return_result
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - instance_name: '${instance_name}'
    - instance_id: '${instance_id}'
    - instance_state: '${instance_state}'
    - vnic_name: '${vnic_name}'
    - vnic_id: '${vnic_id}'
    - vnic_state: '${vnic_state}'
    - vnic_hostname: '${vnic_hostname}'
    - private_ip_address: '${private_ip}'
    - public_ip_address: '${public_ip}'
    - mac_address: '${mac_address}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_instance_details:
        x: 181
        'y': 94
      list_vnic_attachments:
        x: 510
        'y': 85
      send_instance_credentials_mail:
        x: 1015
        'y': 321
        navigate:
          6f2851fe-06f6-d9be-a7fb-7ac23243e6bf:
            targetId: 37478502-260f-98fb-79f8-0775a71e980f
            port: SUCCESS
      get_default_credentials:
        x: 852
        'y': 77
        navigate:
          9fec3acb-aa9a-1a1e-2309-66fdce691752:
            targetId: 37478502-260f-98fb-79f8-0775a71e980f
            port: FAILURE
      create_instance:
        x: 38
        'y': 98
      wait_for_instance_status:
        x: 375
        'y': 320
      counter:
        x: 192
        'y': 313
        navigate:
          0057bf63-6a22-5846-bea0-7ff1775a744a:
            targetId: 3db735cf-df67-3be0-d343-68e02ac7fec9
            port: NO_MORE
      instance_status:
        x: 401
        'y': 68
      get_instance_default_credentials:
        x: 827
        'y': 317
      get_vnic_details:
        x: 657
        'y': 90
    results:
      SUCCESS:
        37478502-260f-98fb-79f8-0775a71e980f:
          x: 1009
          'y': 98
      FAILURE:
        3db735cf-df67-3be0-d343-68e02ac7fec9:
          x: 38
          'y': 328
