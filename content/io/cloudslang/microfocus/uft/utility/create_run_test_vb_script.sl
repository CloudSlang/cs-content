#   Copyright 2018, Micro Focus, L.P.
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
#! @description: This flow creates a VB script needed to run an UFT Scenario based on a
#!               default triggering template.
#!
#!  Notes:
#!  1. This operations uses the Windows Remote Management (WinRM) implementation for WS-Management standard to execute
#!  PowerShell scripts. This operations is designed to run on remote hosts that have PowerShell installed and configured.
#!
#!  The Windows Remote Management (WS-Management) service on the remote host may not be started by default.
#!  Start the service and change its Startup type to Automatic (Delayed Start) before proceeding with the next steps.
#!  On the remote host, open a Command Prompt using the Run as Administrator option and paste in the following lines:
#!    winrm quickconfig
#!    y
#! This command("winrm quickconfig") will start the WinRM service, and set the service startup type to auto-start.
#! Configure a listener for the ports that send and receive WS-Management protocol messages using either
#! HTTP or HTTPS on any IP address.
#!
#! Open the ports for HTTP(5985) and HTTPS(5986).
#! The winrm quickconfig command creates a firewall exception only for the current user profile.
#!
#! By default basic authentication is disabled in WinRM.
#! Enable it if you are going to use local accounts to access the remote host:
#!    winrm set winrm/config/service/Auth @{Basic="true"}
#! Configure WinRM to allow unencrypted SOAP messages:
#!    winrm set winrm/config/service @{AllowUnencrypted="true"}
#! Kerberos authentication type should be enabled by default on the winrm service.
#! If you are not going to use domain accounts to access the remoet host you can disable it:
#!	winrm set winrm/config/service/Auth @{Kerberos="false"}
#!Configure WinRM to provide enough memory to the commands that you are going to run, e.g. 1024 MB:
#!    winrm set winrm/config/winrs @{MaxMemoryPerShellMB="1024"}
#! Manualy Enable the WinRM firewall exception if winrm quickconfig did not work:
#!    netsh advfirewall firewall add rule name="WinRM-HTTP" dir=in localport=5985 protocol=TCP action=allow
#! Run this command to check your configurations:
#!    winrm get Winrm/config
#! Use the following command to enumerate the winrm configured listeners.
#! You should have one for http listening on 5985 and one for https listening on 5986:
#!	winrm enumerate winrm/config/listener
#! The defult ports for WinRM connections are 5985 for HTTP and 5986 for HTTPS protocols.
#! Use netstat -ano | findstr "5985" and netstat -ano | findstr "5986" to check if the ports are opened.
#! Enable “Trust the remote machine” from: “Local Group Policy user interface”  by typing gpedit.msc in the run prompt
#!  Navigate to “Local Computer Policy > Computer Configuration > Administrative Templates > Windows Components >
#!  Windows Remote Management (WinRM) > WinRM Client”. On the setting window, add the remote exchange server name in the
#!  “trustedhostedlist” field.
#!
#! 2. For HTTPS connection do the following:
#! Create a self signed certificate for the remote host.
#! Import the certificate in the client keystore and copy the certificate thumbrpint.
#! Create an HTTPS WinRM listener on the remote host with the thumbprint of the certificate you've just copied.
#!  winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname="HOSTNAME"; CertificateThumbprint="THUMBPRINT"}
#! Do a quickconfig for WinRM with HTTPS:
#!    winrm quickconfig -transport:https
#! Check the complete WinRM configurations and that the listeners have been configured with:
#!    winrm get winrm/config
#! 	winrm enumerate winrm/config/listener
#!
#! 3. Authenticating with domain accounts is possible through kerberos authentication type.
#! Kerberos configurations need to be made both on the client(OO), server(WSMAN) and on the Domain Controller if you
#! are going to use Windows domain accounts to access the remote host.
#! During setup, WinRM creates the local group WinRMRemoteWMIUsers__. WinRM then restricts remote access to any user
#! that is not a member of either the local administration group or the WinRMRemoteWMIUsers__ group.
#! The domain user needs to be a member of this group in order to access resources over WinRM.
#! For the execution of the operation with kerberos authentication you will need to create two configuration files:
#! "login.conf" which contains the principal name of the user and the location of the keytab file associated to that user
#! and "krb5.conf" file which contains the domain name and the kdc hostname.
#! First you need to create the keytab file for the user on the Domain Controller.
#! Open a command prompt and type the following command:
#!    ktpass ﻿/princ username@MYDOMAIN.COM /pass password /ptype KRB5_NT_PRINCIPAL /out username.keytab
#! (OPTIONAL) Now in order to test the keytab, you'll need a copy of kinit.
#! You can use the one from <OO_HOME>\java\bin\kinit.exe. You also need to setup your krb5.ini file and copy it under
#! c:\windows\krb5.ini (on Windows) and /etc/krb5.conf (on Linux).
#! The krb5.ini file content looks like:
#!    [libdefaults]
#!	               default_realm = CONTOSO.COM
#!	[realms]
#!	               CONTOSO.COM = {
#!	                              kdc = ad.contoso.com
#!	                              admin_server = ad.contoso.com
#!    where CONTOSO.COM is your domain name and ad.contoso.com is the fully qualified name of your
#!    KDC server(usually the domain controller).
#! Once you've got your Kerberos file setup, you can use kinit to test the keytab.
#! First, try to logon with your user account without using the keytab:
#!    kinit username@CONTOSO.COM
#!    - enter the password -
#! If that doesn't work, your krb5 file is wrong.  If it does work, now try the keytab file:
#!    kinit username@CONTOSO.COM -k -t username.keytab
#! Now you should successfully authenticate without being prompted for a password.  Success!
#! For the operation inputs kerberosConfFile and kerberosLoginConfFile we need to create the krb5.conf file and
#! login.conf respectively. The content of the krb5.conf file is exactly the same as the krb5.ini file mentioned above.
#! The login.conf file content looks like this:
#!    om.sun.security.jgss.initiate {
#!		com.sun.security.auth.module.Krb5LoginModule required principal=Administrator
#!		doNotPrompt=true
#!		useKeyTab=true
#!		keyTab="file:/C:/Users/Administrator.CONTOSO/krb5.keytab";
#!	};
#!    where Administrator is the principal name of the domain account used to authenticate and the keytab property
#!    contains the path to the keytab file created on the server with the ktpass command mentioned above.
#!
#! The username and password inputs no longer need to be provided when the kerberos configuration files are provided.
#!
#! The operation will request access to a Kerberos service principal name of the form WSMAN/HOST,
#! for which an SPN should be configured automatically when you configure WinRM for a remote host.
#! If that was not configured correctly, you will have configure the service principal names manually.
#! This can be achieved by invoking the setspn command, as an Administrator, on any host in the domain, as follows:
#!    setspn -A PROTOCOL/ADDRESS:PORT WINDOWS-HOST
#!    where:
#!    PROTOCOL is either WSMAN (default) or HTTP.
#!    ADDRESS is the address used to connect to the remote host,
#!    PORT (optional) is the port used to connect to the remote host (usually 5985 or 5986,
#!         only necessary if kerberosSkipPortForLookup has been set to false)
#!    WINDOWS-HOST is the short Windows hostname of the remote host.
#! Some other useful commands:
#!    List all service principal names configured for a domain user: setspn -L <user>
#!    List all service principal names configured for a specific host in the domain: setspn -L <hostname>
#!
#! @input host: The host where UFT scenarios are located.
#! @input port: The WinRM port of the provided host.
#!              Default for https: '5986'
#!              Default for http: '5985'
#! @input protocol: The WinRM protocol.
#! @input username: The username for the WinRM connection.
#! @input password: The password for the WinRM connection.
#! @input is_test_visible: Parameter to set if the UFT scenario actions should be visible in the UI or not.
#! @input test_path: The path to the UFT scenario.
#! @input test_results_path: The path where the UFT scenario will save its results.
#! @input test_parameters: UFT scenario parameters from the UFT scenario. A list of name:value pairs separated by comma.
#!                          Eg. name1:value1,name2:value2
#! @input uft_workspace_path: The path where the OO will create needed scripts for UFT scenario execution.
#! @input script: The run UFT scenario VB script template.
#! @input fileNumber: Used for development purposes
#! @input auth_type:Type of authentication used to execute the request on the target server
#!                  Valid: 'basic', digest', 'ntlm', 'kerberos', 'anonymous' (no authentication).
#!                    Default: 'basic'
#!                    Optional
#! @input proxy_host: The proxy host.
#!                    Optional
#! @input proxy_port: The proxy port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL.
#!                         A certificate is trusted even if no trusted certification authority issued it.
#!                         Valid: 'true' or 'false'
#!                         Default: 'false'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname
#!                                 verification system prevents communication with other hosts other than the ones you
#!                                 intended. This is done by checking that the hostname is in the subject alternative
#!                                 name extension of the certificate. This system is designed to ensure that, if an
#!                                 attacker(Man In The Middle) redirects traffic to his machine, the client will not
#!                                 accept the connection. If you set this input to "allow_all", this verification is
#!                                 ignored and you become vulnerable to security attacks. For the value
#!                                 "browser_compatible" the hostname verifier works the same way as Curl and Firefox.
#!                                 The hostname must match either the first CN, or any of the subject-alts. A wildcard
#!                                 can occur in the CN, and in any of the subject-alts. The only difference between
#!                                 "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with
#!                                 "browser_compatible" matches all subdomains, including "a.b.foo.com".
#!                                 From the security perspective, to provide protection against possible
#!                                 Man-In-The-Middle attacks, we strongly recommend to use "strict" option.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'.
#!                                 Default: 'strict'.
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: 'JAVA_HOME/java/lib/security/cacerts'
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Default value: 'changeit'
#!                        Optional
#! @input operation_timeout: Defines the operation_timeout value in seconds to indicate that the clients expect a
#!                           response or a fault within the specified time.
#!                           Default: '60'
#!
#! @output script_name: Full path VB script
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output return_result: The scripts result.
#! @output stderr: An error message in case there was an error while running power shell
#! @output script_exit_code: '0' if success, '-1' otherwise.
#! @output fileExists: file exist.
#!
#! @result SUCCESS: The operation executed successfully.
#! @result FAILURE: The operation could not be executed.
#!!#
########################################################################################################################

namespace: io.cloudslang.microfocus.uft.utility

imports:
  strings: io.cloudslang.base.strings
  ps: io.cloudslang.base.powershell
  math: io.cloudslang.base.math
  prop: io.cloudslang.microfocus.uft

flow:
  name: create_run_test_vb_script
  inputs:
    - host
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - port:
        required: false
    - protocol:
        required: false
    - is_test_visible: 'True'
    - test_path
    - test_results_path
    - test_parameters
    - name_value_delimiter:
        default: ':'
        required: true
    - uft_workspace_path
    -  auth_type:
        default: 'basic'
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: 'strict'
        required: false
    - trust_keystore:
        default: ''
        required: false
    - trust_password:
        default: 'changeit'
        required: false
        sensitive: true
    - operation_timeout:
        default: '60'
        required: false
    - script: ${get_sp('io.cloudslang.microfocus.uft.run_robot_script_template')}
    - fileNumber:
        default: '0'
        private: true

  workflow:
    - add_test_path:
        do:
          strings.search_and_replace:
            - origin_string: '${script}'
            - text_to_replace: '<test_path>'
            - replace_with: '${test_path}'
        publish:
          - script: '${replaced_string}'
        navigate:
          - SUCCESS: add_test_results_path
          - FAILURE: on_failure
    - create_vb_script:
        do:
          ps.powershell_script:
            - host
            - port
            - protocol
            - username
            - password:
                value: '${password}'
                sensitive: true
            - auth_type
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password:
                value: '${trust_password}'
                sensitive: true
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - operation_timeout
            - script: "${'Set-Content -Path \"' + uft_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + test_path.split(\"\\\\\")[-1] + '_' + fileNumber + '.vbs\" -Value \"'+ script +'\" -Encoding ASCII'}"
        publish:
          - exception
          - return_code
          - return_result
          - script_exit_code
          - stderr
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - add_test_results_path:
        do:
          strings.search_and_replace:
            - origin_string: '${script}'
            - text_to_replace: '<test_results_path>'
            - replace_with: '${test_results_path}'
        publish:
          - script: '${replaced_string}'
        navigate:
          - SUCCESS: is_test_visible
          - FAILURE: on_failure
    - add_parameter:
        loop:
          for: "parameter in test_parameters.replace(\"\\,\',\"§\")"
          do:
            strings.append:
              - origin_string: "${get('text', '')}"
              - text: "${'qtParams.Item(`\"' + parameter.split(name_value_delimiter)[0] + '`\").Value = `\"' + parameter.split(name_value_delimiter)[1] +'`\"`r`n'}"
          break: []
          publish:
            - text: '${new_string.replace(\"§\",\"\\\\,\")}'
        navigate:
          - SUCCESS: add_parameters
    - add_parameters:
        do:
          strings.search_and_replace:
            - origin_string: '${script}'
            - text_to_replace: '<params>'
            - replace_with: '${text}'
        publish:
          - script: '${replaced_string}'
        navigate:
          - SUCCESS: create_folder_structure
          - FAILURE: on_failure
    - is_test_visible:
        do:
          strings.search_and_replace:
            - origin_string: '${script}'
            - text_to_replace: '<visible_param>'
            - replace_with: '${is_test_visible}'
        publish:
          - script: '${replaced_string}'
        navigate:
          - SUCCESS: add_parameter
          - FAILURE: on_failure
    - create_folder_structure:
        do:
          ps.powershell_script:
            - host
            - port
            - protocol
            - username
            - password:
                value: '${password}'
                sensitive: true
            - auth_type
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - operation_timeout
            - script: "${'New-item \"' + uft_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + '\" -ItemType Directory -force'}"
        publish:
          - exception
          - stderr
          - return_result
          - return_code
          - script_exit_code
          - scriptName: output_0
        navigate:
          - SUCCESS: check_if_filename_exists
          - FAILURE: on_failure
    - check_if_filename_exists:
        do:
          ps.powershell_script:
            - host
            - port
            - protocol
            - username
            - password:
                value: '${password}'
                sensitive: true
            - auth_type
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - operation_timeout
            - script: "${'Test-Path \"' + uft_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + test_path.split(\"\\\\\")[-1] + '_' + fileNumber +  '.vbs\"'}"
        publish:
          - exception
          - stderr
          - return_result
          - return_code
          - script_exit_code
          - fileExists: '${return_result}'
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - string_equals:
        do:
          strings.string_equals:
            - first_string: '${fileExists}'
            - second_string: 'True'
        navigate:
          - SUCCESS: add_numbers
          - FAILURE: create_vb_script
    - add_numbers:
        do:
          math.add_numbers:
            - value1: '${fileNumber}'
            - value2: '1'
        publish:
          - fileNumber: '${result}'
        navigate:
          - SUCCESS: check_if_filename_exists
          - FAILURE: on_failure

  outputs:
    - script_name: "${uft_workspace_path.rstrip(\"\\\\\") + \"\\\\\" + test_path.split(\"\\\\\")[-1] + '_' + fileNumber + '.vbs'}"
    - exception
    - stderr
    - return_result
    - return_code
    - script_exit_code

    - fileExists

  results:
    - FAILURE
    - SUCCESS

extensions:
  graph:
    steps:
      create_folder_structure:
        x: 1108
        y: 56
      add_parameters:
        x: 893
        y: 53
      check_if_filename_exists:
        x: 1101
        y: 300
      add_parameter:
        x: 675
        y: 56
      add_numbers:
        x: 908
        y: 506
      string_equals:
        x: 936
        y: 278
      add_test_path:
        x: 40
        y: 58
      is_test_visible:
        x: 461
        y: 55
      create_vb_script:
        x: 502
        y: 286
        navigate:
          c3db07a5-d125-3877-5aba-a4077607d789:
            targetId: 09dd53a1-80a5-775c-ecf2-2930999b2b46
            port: SUCCESS
      add_test_results_path:
        x: 251
        y: 57
    results:
      SUCCESS:
        09dd53a1-80a5-775c-ecf2-2930999b2b46:
          x: 498
          y: 514
