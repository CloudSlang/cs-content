#   (c) Copyright 2018 Micro Focus
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
#! @description: This flow returns the existing robots in a provided path.
#!
#! @input host: The host where UFT and robots (UFT scenarios) are located.
#! @input port: The WinRM port of the provided host.
#!                    Default: https: '5986' http: '5985'
#! @input protocol: The WinRM protocol.
#! @input username: The username for the WinRM connection.
#! @input password: The password for the WinRM connection.
#! @input robots_path: The path where the robots(UFT scenarios) are located.
#! @input iterator: Used for development purposes.
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
#! @output robots: UFT robots list from the specified path.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output stderr: An error message in case there was an error while running power shell
#! @output script_exit_code: '0' if success, '-1' otherwise.
#! @output folders: folders from the specified path.
#! @output test_file_exists: file exist.
#!
#! @result SUCCESS: The operation executed successfully.
#! @result FAILURE: The operation could not be executed.
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
#!!#
########################################################################################################################

namespace: io.cloudslang.rpa.uft

flow:
  name: get_robots
  inputs:
    - host
    - port:
        required: false
    - protocol:
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
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
    - robots_path
    - iterator:
        default: '0'
        private: true

  workflow:
    - get_folders:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - auth_type: '${auth_type}'
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
            - operation_timeout: '${operation_timeout}'
            - script: "${'(Get-ChildItem -Path \"'+ robots_path +'\" -Directory).Name -join \",\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
          - folders: "${return_result.replace('\\n',',')}"
        navigate:
          - SUCCESS: length
          - FAILURE: on_failure
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${test_file_exists}'
            - second_string: 'True'
        navigate:
          - SUCCESS: append
          - FAILURE: add_numbers
    - test_file_exists:
        do:
          io.cloudslang.base.powershell.powershell_script:
            - host: '${host}'
            - port: '${port}'
            - protocol: '${protocol}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - auth_type: '${auth_type}'
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
            - operation_timeout: '${operation_timeout}'
            - script: "${'Test-Path \"' + robots_path.rstrip(\\\\) + \"\\\\\" + folder_to_check + '\\\\Test.tsp\"'}"
        publish:
          - exception
          - return_code
          - stderr
          - script_exit_code
          - test_file_exists: "${return_result.replace('\\n',',')}"
        navigate:
          - SUCCESS: string_equals
          - FAILURE: on_failure
    - length:
        do:
          io.cloudslang.base.lists.length:
            - list: '${folders}'
        publish:
          - list_length: '${return_result}'
        navigate:
          - SUCCESS: is_done
          - FAILURE: on_failure
    - is_done:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${iterator}'
            - second_string: '${list_length}'
        navigate:
          - SUCCESS: default_if_empty
          - FAILURE: get_by_index
    - add_numbers:
        do:
          io.cloudslang.base.math.add_numbers:
            - value1: '${iterator}'
            - value2: '1'
        publish:
          - iterator: '${result}'
        navigate:
          - SUCCESS: is_done
          - FAILURE: on_failure
    - append:
        do:
          io.cloudslang.base.strings.append:
            - origin_string: "${get('robots_list', '')}"
            - text: "${folder_to_check + ','}"
        publish:
          - robots_list: '${new_string}'
        navigate:
          - SUCCESS: add_numbers
    - get_by_index:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${folders}'
            - delimiter: ','
            - index: '${iterator}'
        publish:
          - folder_to_check: '${return_result}'
        navigate:
          - SUCCESS: test_file_exists
          - FAILURE: on_failure
    - default_if_empty:
        do:
          io.cloudslang.base.utils.default_if_empty:
            - initial_value: "${get('robots_list', '')}"
            - default_value: No robots founded in the provided path.
        publish:
          - robots_list: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - robots: '${robots_list.rstrip(",")}'
    - exception: ${get('exception', '')}
    - return_code: ${get('return_code', '')}
    - stderr: ${get('stderr', '')}
    - script_exit_code: ${get('script_exit_code', '')}
    - folders: ${get('folders', '')}
    - test_file_exists: ${get('test_file_exists', '')}

  results:
    - SUCCESS
    - FAILURE

extensions:
  graph:
    steps:
      length:
        x: 250
        y: 77
      default_if_empty:
        x: 637
        y: 80
        navigate:
          0579a2e1-65b5-64bc-6afb-87ae9d3dcfbb:
            targetId: 023c90fc-05ed-adf3-eb3c-da02c1f4333a
            port: SUCCESS
      add_numbers:
        x: 251
        y: 256
      string_equals:
        x: 289
        y: 416
      test_file_exists:
        x: 428
        y: 422
      get_by_index:
        x: 424
        y: 250
      is_done:
        x: 462
        y: 62
      append:
        x: 80
        y: 429
      get_folders:
        x: 53
        y: 80
    results:
      SUCCESS:
        023c90fc-05ed-adf3-eb3c-da02c1f4333a:
          x: 849
          y: 83
