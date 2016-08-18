#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
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
#! @input username: optional - username used for URL authentication; for NTLM authentication, the required format is
#!                  'domain\user'
#! @input password: optional - password used for URL authentication
#! @input proxy_host: optional - proxy server used to access the web site
#! @input proxy_port: optional - proxy server port - Default: '8080'
#! @input proxy_username: optional - user name used when connecting to the proxy
#! @input proxy_password: optional - proxy server password associated with the <proxy_username> input value
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trustAllRoots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: ''
#! @input keystore: optional - the pathname of the Java KeyStore file. You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: optional - the password associated with the KeyStore file. If trustAllRoots is false and keystore
#!                           is empty, keystorePassword default will be supplied.
#!                           Default value: ''
#! @input secure_processing: optional -  sets the secure processing feature
#!                           "http://javax.xml.XMLConstants/feature/secure-processing" to be true or false when parsing
#!                           the xml document or string. (true instructs the implementation to process XML securely.
#!                           This may set limits on XML constructs to avoid conditions such as denial of service attacks)
#!                           and (false instructs the implementation to process XML in accordance with the XML specifications
#!                           ignoring security issues such as limits on XML constructs to avoid conditions such as
#!                           denial of service attacks)
#!                           Default value: 'true'
#!                           Accepted values: 'true' or 'false'
#! @output return_result: parsing was successfull or valid xml
#! @output return_code: 0 if success, -1 if failure
#! @output error_message: exception in case of failure
#! @result SUCCESS: XML is well-formed and is valid based on XSD if given
#! @result FAILURE: XML is not well-formed or is not valid based on given XSD
#!!#
####################################################

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
    gav: 'io.cloudslang.content:cs-xml:0.0.6'
    class_name: io.cloudslang.content.xml.actions.Validate
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - error_message: ${errorMessage}
    - return_code: ${returnCode}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
