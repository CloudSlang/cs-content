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
#! @description: Performs a VMware vSphere command in order to customize an existing linux OS based virtual machine.
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
#! @input port: Port to connect through
#!              Examples: '443', '80'
#!              Default: '443'
#!              Optional
#! @input protocol: Connection protocol.
#!                  Valid: 'http', 'https'
#!                  Default: 'https'
#!                  Optional
#! @input username: VMware username to connect with.
#! @input password: Password associated with <username> input.
#! @input trust_everyone: If 'true', will allow connections from any host, if 'false', connection will be
#!                        allowed only using a valid vCenter certificate.
#!                        Check https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_java_development.4.3.html
#!                        to see how to import a certificate into Java Keystore and
#!                        https://pubs.vmware.com/vsphere-50/index.jsp?topic=%2Fcom.vmware.wssdk.dsg.doc_50%2Fsdk_sg_server_certificate_Appendix.6.4.html
#!                        to see how to obtain a valid vCenter certificate.
#!                        Default: 'true'
#!                        Optional
#! @input virtual_machine_name: Name of linux OS based virtual machine that will be customized.
#! @input computer_name: The network host name of the (Linux) virtual machine.
#! @input domain: The fully qualified domain name.
#!                Default: ''
#!                Optional
#! @input ip_address: The static ip address. If specified then the <subnet_mask> and <default_gateway>
#!                    inputs should be specified as well.
#!                    Default: ''
#!                    Optional
#! @input subnet_mask: The subnet mask for the virtual network adapter. If specified then the <ip_address> and
#!                     <default_gateway> inputs should be specified as well.
#!                     Default: ''
#!                     Optional
#! @input default_gateway: The default gateway for network adapter with a static IP address. If specified then the
#!                         <ip_address> and <subnet_mask> inputs should be specified as well.
#!                         Default: ''
#!                         Optional
#! @input hw_clock_utc: Specifies whether the hardware clock is in UTC or local time.
#!                      True when the hardware clock is in UTC.
#!                      Default: 'true'
#!                      Optional
#! @input time_zone: The time zone for the new virtual machine. The case-sensitive timezone, such as 'Area/Location'
#!                   Valid: 'Europe/Bucharest'
#!                   Default: ''
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
  name: customize_linux_guest

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
    - computer_name
    - computerName:
        default: ${get("computer_name", "")}
        private: true
    - domain:
        default: ''
        required: false
    - ip_address:
        required: false
    - ipAddress:
        default: ${get("ip_address", "")}
        private: true
        required: false
    - subnet_mask:
        required: false
    - subnetMask:
        default: ${get("subnet_mask", "")}
        private: true
        required: false
    - default_gateway:
        required: false
    - defaultGateway:
        default: ${get("default_gateway", "")}
        private: true
        required: false
    - hw_clock_utc:
        required: false
    - hwClockUTC:
        default: ${get("hw_clock_utc", "true")}
        private: true
    - time_zone:
        required: false
    - timeZone:
        default: ${get("time_zone", "")}
        private: true
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-vmware:0.0.30'
    class_name: io.cloudslang.content.vmware.actions.guest.CustomizeLinuxGuest
    method_name: customizeLinuxGuest

  outputs:
    - return_result: ${get("returnResult", "")}
    - error_message: ${get("exception", returnResult if returnCode != '0' else '')}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
