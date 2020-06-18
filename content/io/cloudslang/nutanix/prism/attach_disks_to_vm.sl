########################################################################################################################
#!!
#! @input hostname: The hostname for Nutanix.
#! @input port: The port to connect to Nutanix.Default: '9440'Optional
#! @input username: The username for Nutanix.
#! @input password: The password for Nutanix.
#! @input vm_uuid: Id of the Virtual Machine.
#! @input device_bus_list: Device Bus List. List the device buses in the same order that the disk UUIDs are listed, separated by commas.Valid values: sata,scsi,ide,pci
#! @input device_index_list: Device indices list. List the device index in the same order that the disk UUIDs are listed,separated by commas.Optional
#! @input device_disksize_list: Size of the each disk to be attached to the VM.
#! @input storagecontainer_uuid_disk_list: Storage container UUID for each disk to be to attached the VM.
#! @input api_version: The api version for Nutanix.Default: 'v2.0'Optional
#! @input proxy_host: Proxy server used to access the Nutanix service.Optional
#! @input proxy_port: Proxy server port used to access the Nutanix service.Default: '8080'Optional
#! @input proxy_username: Proxy server user name.Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if notrusted certification authority issued it.Default: 'false'Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject'sCommon Name (CN) or subjectAltName field of the X.509 certificate. Set this to"allow_all" to skip any checking. For the value "browser_compatible" the hostnameverifier works the same way as Curl and Firefox. The hostname must match either thefirst CN, or any of the subject-alts. A wildcard can occur in the CN, and in any ofthe subject-alts. The only difference between "browser_compatible" and "strict" isthat a wildcard (such as "*.foo.com") with "browser_compatible" matches allsubdomains, including "a.b.foo.com".Default: 'strict'Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties thatyou expect to communicate with, or from Certificate Authorities that you trust to identifyother parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is'true' this input is ignored. Format: Java KeyStore (JKS)Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystoreis empty, trustPassword default will be supplied.Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'represents an infinite timeout.Default: '10000'Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive datapackets), in seconds. A socketTimeout value of '0' represents an infinite timeout.Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. IfkeepAlive is false, the already open connection will be used and after execution it will closeit.Default: 'true'Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.Default: '2'Optional
#! @input connections_max_total: The maximum limit of connections in total.Default: '20'Optional
#!!#
########################################################################################################################
namespace: io.test
flow:
  name: attach_disk_to_vm
  inputs:
    - hostname: 15.114.162.124
    - port:
        required: false
    - username: admin
    - password:
        default: ********
        sensitive: true
    - vm_uuid: 0b5d5c1c-40c8-4591-9f02-72e2ce4d5b6f
    - device_bus_list: scsi
    - device_index_list:
        required: false
    - device_disksize_list: '10'
    - storagecontainer_uuid_disk_list: 891a9fab-9484-4947-8c7d-155701cdee20
    - api_version:
        required: false
    - proxy_host:
        default: web-proxy.us.softwaregrp.net
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: 'true'
        required: false
    - x_509_hostname_verifier:
        default: allow_all
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
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
  workflow:
    - attach_disks:
        do:
          io.cloudslang.nutanix.prism.disks.attach_disks:
            - hostname: '${hostname}'
            - port: '${port}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_uuid: '${vm_uuid}'
            - device_bus_list: '${device_bus_list}'
            - device_index_list: '${device_index_list}'
            - device_disksize_list: '${device_disksize_list}'
            - storagecontainer_uuid_disk_list: '${storagecontainer_uuid_disk_list}'
            - api_version: '${api_version}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
        publish:
          - task_uuid
        navigate:
          - SUCCESS: get_task_details
          - FAILURE: FAILURE
    - get_task_details:
        do:
          io.cloudslang.nutanix.prism.tasks.get_task_details:
            - hostname: '${hostname}'
            - port: '${port}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - task_uuid: '${task_uuid}'
            - include_subtasks_info: '${include_subtasks_info}'
            - api_version: '${api_version}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
        publish:
          - task_status
        navigate:
          - SUCCESS: is_task_status_succeeded
          - FAILURE: FAILURE
    - wait_for_task_status_success:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '10'
        navigate:
          - SUCCESS: get_task_details
          - FAILURE: FAILURE
    - iterate_for_task_status:
        do:
          io.cloudslang.nutanix.prism.utils.counter:
            - from: '1'
            - to: '30'
            - increment_by: '1'
        navigate:
          - HAS_MORE: wait_for_task_status_success
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - is_task_status_succeeded:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${task_status}'
            - second_string: Succeeded
        publish: []
        navigate:
          - SUCCESS: get_vm_details
          - FAILURE: iterate_for_task_status
    - success_message:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: 'Successfully Attached disk to the VM : '
            - text: '${vm_name}'
        publish:
          - return_result: '${new_string}'
        navigate:
          - SUCCESS: SUCCESS
    - get_vm_details:
        do:
          io.cloudslang.nutanix.prism.virtualmachines.get_vm_details:
            - hostname: '${hostname}'
            - port: '${port}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_uuid: '${vm_uuid}'
            - include_vm_disk_config_info: '${include_vm_disk_config_info}'
            - include_vm_nic_config_info: '${include_vm_nic_config_info}'
            - api_version: '${api_version}'
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
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
        publish:
          - vm_name
          - ip_address
          - mac_address
          - power_state
          - vm_disk_uuid
          - storage_container_uuid
          - vm_logical_timestamp
        navigate:
          - SUCCESS: success_message
          - FAILURE: FAILURE
  outputs:
    - vm_name: '${vm_name}'
  results:
    - FAILURE
    - SUCCESS
