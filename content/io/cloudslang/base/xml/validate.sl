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
#! @description: Tests an XML string for well-formedness and validates it against an XSD if given.
#!
#! @input xml_document: XML string, file or url to test
#! @input xml_document_source: xml document type
#!                             Default value: 'xmlString'
#!                             Accepted values: 'xmlString', 'xmlPath', 'xmlUrl'
#! @input xsd_document: XSD to test given XML against
#!                      optional
#! @input xsd_document_source: xsd document type
#!                             Default value: 'xsdString'
#!                             Accepted values: 'xsdString', 'xsdPath', 'xsdUrl'
#! @input username: Optional - username used for URL authentication; for NTLM authentication, the required format is
#!                  'domain\user'
#! @input password: Optional - password used for URL authentication
#! @input trust_all_roots: Optional - specifies whether to enable weak security over SSL - Default: false
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname
#!                                 verification system prevents communication with other hosts other than the ones
#!                                 you intended. This is done by checking that the hostname is in the subject
#!                                 alternative name extension of the certificate. This system is designed to ensure that,
#!                                 if an attacker(Man In The Middle) redirects traffic to his machine, the client will
#!                                 not accept the connection. If you set this input to "allow_all", this verification is
#!                                 ignored and you become vulnerable to security attacks. For the value
#!                                 "browser_compatible" the hostname verifier works the same way as Curl and Firefox.
#!                                 The hostname must match either the first CN, or any of the subject-alts.
#!                                 A wildcard can occur in the CN, and in any of the subject-alts. The only
#!                                 difference between "browser_compatible" and "strict" is that a wildcard
#!                                 (such as "*.foo.com") with "browser_compatible" matches all subdomains,
#!                                 including "a.b.foo.com". From the security perspective, to provide protection against
#!                                 possible Man-In-The-Middle attacks, we strongly recommend to use "strict" option.
#!                                Valid values are 'strict', 'browser_compatible', 'allow_all'.
#!                                Default value is 'strict'.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - user name used when connecting to the proxy
#! @input proxy_password: Optional - proxy server password associated with the <proxy_username> input value
#! @input trust_keystore: Optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trustAllRoots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - the password associated with the TrustStore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Default value: ''
#! @input keystore: Optional - the pathname of the Java KeyStore file. You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: Optional - the password associated with the KeyStore file. If trustAllRoots is false and keystore
#!                           is empty, keystorePassword default will be supplied.
#!                           Default value: ''
#! @input secure_processing: Optional -  sets the secure processing feature
#!                           "http://javax.xml.XMLConstants/feature/secure-processing" to be true or false when parsing
#!                           the xml document or string. (true instructs the implementation to process XML securely.
#!                           This may set limits on XML constructs to avoid conditions such as denial of service attacks)
#!                           and (false instructs the implementation to process XML in accordance with the XML specifications
#!                           ignoring security issues such as limits on XML constructs to avoid conditions such as
#!                           denial of service attacks)
#!                           Default value: 'true'
#!                           Accepted values: 'true' or 'false'
#!
#! @output return_result: Parsing was successful or valid xml
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: Exception in case of failure
#!
#! @result SUCCESS: XML is well-formed and is valid based on XSD if given
#! @result FAILURE: XML is not well-formed or is not valid based on given XSD
#!!#
########################################################################################################################

namespace: io.cloudslang.base.xml

operation:
  name: validate

  inputs:
    - xml_document
    - xmlDocument:
        default: ${get("xml_document", "")}
        required: false
        private: true
    - xml_document_source:
        required: false
    - xmlDocumentSource:
        default: ${get("xml_document_source", "xmlString")}
        private: true
    - xsd_document:
        required: false
    - xsdDocument:
        default: ${get("xsd_document", "")}
        required: false
        private: true
    - xsd_document_source:
        required: false
    - xsdDocumentSource:
        default: ${get("xsd_document_source", "xsdString")}
        private: true
    - username:
        required: false
        default: ''
    - password:
        required: false
        sensitive: true
        default: ''
    - trust_all_roots:
        required: false
        default: 'false'
    - trustAllRoots:
        default: ${get("trust_all_roots", "")}
        required: false
        private: true
    - keystore:
        required: false
        default: ''
    - keystore_password:
        required: false
        sensitive: true
        default: ''
    - keystorePassword:
        default: ${get("keystore_password", "")}
        required: false
        private: true
    - trust_keystore:
        required: false
        default: ''
    - trustKeystore:
        default: ${get("trust_keystore", "")}
        required: false
        private: true
    - trust_password:
        required: false
        sensitive: true
        default: ''
    - trustPassword:
        default: ${get("trust_password", "")}
        required: false
        private: true
    - x_509_hostname_verifier:
        required: false
        default: 'strict'
    - x509HostnameVerifier:
        default: ${get("x_509_hostname_verifier", "")}
        required: false
        private: true
    - proxy_host:
        required: false
        default: ''
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        required: false
        default: '8080'
    - proxyPort:
        default: ${get("proxy_port", "")}
        required: false
        private: true
    - proxy_username:
        required: false
        default: ''
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
        default: ''
    - proxyPassowrd:
        default: ${get("proxy_password", "")}
        required: false
        private: true
    - secure_processing:
        required: false
    - secureProcessing:
        default: ${get("secure_processing", "true")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-xml:0.0.11'
    class_name: io.cloudslang.content.xml.actions.Validate
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - error_message: ${errorMessage}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
