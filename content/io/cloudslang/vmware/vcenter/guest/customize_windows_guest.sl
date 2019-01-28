#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Performs a VMware vSphere command in order to customize an existing Windows OS based virtual machine.
#!
#! @prerequisites: vim25.jar
#!   How to obtain the vim25.jar:
#!     1. Go to https://my.vmware.com/web/vmware and register.
#!     2. Go to https://my.vmware.com/group/vmware/get-download?downloadGroup=MNGMTSDK600
#!        and download the VMware-vSphere-SDK-6.0.0-2561048.zip.
#!     3. Locate the vim25.jar in ../VMware-vSphere-SDK-6.0.0-2561048/SDK/vsphere-ws/java/JAXWS/lib.
#!     4. Copy the vim25.jar into the ClodSlang CLI folder under /cslang/lib.
#!
#! @input host: VMware host or IP.
#!              Example: 'vc6.subdomain.example.com'
#! @input port: port to connect through
#!              Examples: '443', '80'
#!              Default: '443'
#!              Optional
#! @input protocol: Connection protocol.
#!                  Optional
#!                  Valid: 'http', 'https'
#!                  Default: 'https'
#! @input username: VMware username to connect with.
#! @input password: Password associated with <username> input.
#! @input trust_everyone: If 'True', will allow connections from any host, if 'False', connection will be
#!                        allowed only using a valid vCenter certificate
#!                        Check https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_java_development.4.3.html
#!                        to see how to import a certificate into Java Keystore and
#!                        https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_sg_server_certificate_Appendix.6.4.html
#!                        to see how to obtain a valid vCenter certificate.
#!                        Default: 'true'
#!                        Optional
#! @input virtual_machine_name: Name of Windows OS based virtual machine that will be customized
#! @input reboot_option: Specifies whether to shutdown, reboot or not the machine in the customization process
#!                       Valid: 'noreboot', 'reboot', 'shutdown'
#!                       Default: 'reboot'
#! @input computer_name: The network host name of the (Windows) virtual machine.
#! @input computer_password: The new password for the (Windows) virtual machine. This cannot be set to empty string in
#!                           order to remove the existing computer password.
#! @input owner_name: The user's full name.
#! @input owner_organization: The user's organization.
#! @input product_key: A valid serial number to be included in the answer file.
#!                     Default: ''
#!                     Optional
#! @input domain_username: The domain user account used for authentication if the virtual machine is joining a domain.
#!                         The user must have the privileges required to add computers to the domain.
#!                         Default: ''
#!                         Optional
#! @input domain_password: The password for the domain user account used for authentication if the virtual machine is
#!                         joining a domain.
#!                         default: ''
#! @input domain: The fully qualified domain name.
#!                Default: ''
#!                Optional
#! @input workgroup: The workgroup that the virtual machine should join. If this is supplied,
#!                   then the domain name and authentication fields should not be supplied (mutually exclusive).
#!                   Default: ''
#!                   Optional
#! @input license_data_mode: The type of the windows license. 'perServer' indicates that a client access license has been
#!                           purchased for each computer that accesses the VirtualCenter server. 'perSeat' indicates that
#!                           client access licenses have been purchased for the server, allowing a certain number of concurrent
#!                           connections to the VirtualCenter server.
#!                           Valid: '', ''perServer', 'perSeat'
#!                           Default: 'perServer'
#! @input dns_server: The server IP address to use for DNS lookup in a Windows guest operating system
#!                    Default: ''
#! @input ip_address: Optional - the static ip address. If specified then the <subnet_mask> and <default_gateway> inputs
#!                    should be specified as well
#!                    Default: ''
#! @input subnet_mask: The subnet mask for the virtual network adapter. If specified then the <ip_address> and
#!                     <default_gateway> inputs should be specified as well
#!                     Default: ''
#!                     Optional
#! @input default_gateway: The default gateway for network adapter with a static IP address. If specified then the
#!                         <ip_address> and <subnet_mask> inputs should be specified as well
#!                         Default: ''
#!                         Optional
#! @input mac_address: The MAC address for network adapter with a static IP address.
#!                     Default: ''
#!                     Optional
#! @input auto_logon: Specifies whether or not the machine automatically logs on as Administrator.
#!                    Valid: '', ''true', 'false'
#!                    Default: ''
#!                    Optional
#! @input delete_accounts: Specifies whether if all user accounts will be removed from the system as part of the customization
#!                         or not. This input can be use only for older than API 2.5 versions. Since API 2.5 this value
#!                         is ignored and removing user accounts during customization is no longer supported. For older
#!                         API versions: if deleteAccounts is true, then all user accounts are removed from the system
#!                         as part of the customization. Mini-setup creates a new Administrator account with a blank password
#!                         Default: ''
#!                         Optional
#! @input change_sid: Specifies whether the customization process should modify or not the machine's security identifier
#!                    (SID). For Vista OS, SID will always be modified
#!                    Valid: 'true', 'false'
#!                    Default: 'true'
#! @input auto_logon_count: If the AutoLogon flag is set, then the AutoLogonCount property specifies the number of times
#!                          the machine should automatically log on as Administrator. Generally it should be 1, but if
#!                          your setup requires a number of reboots, you may want to increase it
#!                          Default: ''
#!                          Optional
#! @input auto_users: This key is valid only if license_data_mode input is set 'perServer', otherwise is ignored. The
#!                    integer value indicates the number of client licenses purchased for the VirtualCenter server being
#!                    installed
#!                    Default: ''
#!                    Optional
#! @input time_zone: The time zone for the new virtual machine according with
#!                   https://technet.microsoft.com/en-us/library/ms145276%28v=sql.90%29.aspx
#!                   Default: '0'
#!                   Optional
#!
#! @output return_result: Contains the exception in case of failure, success message otherwise.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output error_message: Error message if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: Virtual machine was successfully cloned.
#! @result FAILURE: An error occurred when trying to clone an existing virtual machine.
#!!#
########################################################################################################################

namespace: io.cloudslang.vmware.vcenter.guest

operation:
  name: customize_windows_guest

  inputs:
    - host
    - port:
        default: '443'
        required: false
    - protocol:
        default: 'https'
        required: false
    - username
    - password:
        sensitive: true
    - trust_everyone:
        required: false
    - trustEveryone:
        default: ${get("trust_everyone", "true")}
        private: true
    - virtual_machine_name
    - virtualMachineName:
        default: ${get("virtual_machine_name", "")}
        private: true
    - reboot_option:
        default: 'reboot'
    - rebootOption:
        default: ${get("reboot_option", "")}
        private: true
    - computer_name
    - computerName:
        default: ${get("computer_name", "")}
        required: false
        private: true
    - computer_password
    - computerPassword:
        default: ${get("computer_password", "")}
        required: false
        private: true
    - owner_name
    - ownerName:
        default: ${get("owner_name", "")}
        private: true
    - owner_organization
    - ownerOrganization:
        default: ${get("owner_organization", "")}
        required: false
        private: true
    - product_key:
        required: false
    - productKey:
        default: ${get("product_key", "")}
        required: false
        private: true
    - domain_username:
        required: false
    - domainUsername:
        default: ${get("domain_username", "")}
        required: false
        private: true
    - domain_password:
        required: false
    - domainPassword:
        default: ${get("domain_password", "")}
        private: true
        required: false
    - domain:
        default: ''
        required: false
    - workgroup:
        default: ''
        required: false
    - license_data_mode:
        default: 'perServer'
    - licenseDataMode:
        default: ${get("license_data_mode", "")}
        required: false
        private: true
    - dns_server:
        required: false
    - dnsServer:
        default: ${get("dns_server", "")}
        required: false
        private: true
    - ip_address:
        required: false
    - ipAddress:
        default: ${get("ip_address", "")}
        required: false
        private: true
    - subnet_mask:
        required: false
    - subnetMask:
        default: ${get("subnet_mask", "")}
        required: false
        private: true
    - default_gateway:
        required: false
    - defaultGateway:
        default: ${get("default_gateway", "")}
        required: false
        private: true
    - mac_address:
        required: false
    - macAddress:
        default: ${get("mac_address", "")}
        required: false
        private: true
    - auto_logon:
        required: false
    - autoLogon:
        default: ${get("auto_logon", "false")}
        private: true
    - delete_accounts:
        required: false
    - deleteAccounts:
        default: ${get("delete_accounts", "")}
        required: false
        private: true
    - change_sid:
        default: 'true'
    - changeSID:
        default: ${get("change_sid", "")}
        required: false
        private: true
    - auto_logon_count:
        required: false
    - autoLogonCount:
        default: ${get("auto_logon_count", "1")}
        private: true
    - auto_users:
        required: false
    - autoUsers:
        default: ${get("auto_users", "")}
        required: false
        private: true
    - time_zone:
        required: false
    - timeZone:
        default: ${get("time_zone", "0")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-vmware:0.0.21'
    class_name: io.cloudslang.content.vmware.actions.guest.CustomizeWindowsGuest
    method_name: customizeWindowsGuest

  outputs:
    - return_result: ${get("returnResult", "")}
    - error_message: ${get("exception", returnResult if returnCode != '0' else '')}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
