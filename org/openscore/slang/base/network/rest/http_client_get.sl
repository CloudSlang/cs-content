#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#   This operation will execute an HTTP GET call.
#
#   Inputs:
#       - url - The URL to which the call is made
#       - username - user name used for URL authentication; for NTLM authentication, the required format is 'domain\user'
#       - password - password used for URL authentication
#       - authType - optional - type of authentication used by this operation when trying to execute the request on the target server;
#                  - valid: basic, form, springForm, digest, ntlm, kerberos, anonymous (no authentication) - Default: anonymous
#       - kerberosConfFile - optional - path to the Kerberos configuration file - Default: 0
#       - socketTimeout - time to wait for data to be retrieved, in milliseconds - Default: 0
#       - useCookies - optional - specifies whether to enable cookie tracking or not - Default: true
#       - followRedirects - specifies whether the 'Get' command automatically follows redirects - Default: false
#       - proxy - optional - proxy server used to access the web site
#       - proxyPort - optional - proxy server port - Default: 8080
#       - proxyUsername - optional - user name used when connecting to the proxy
#       - proxyPassword - optional - proxy server password associated with the <proxyUsername> input value
#       - characterSet - optional - character encoding to be used for the HTTP 'Get' request and response - Default: UTF-8
#       - trustAllRoots - optional - specifies whether to enable weak security over SSL - Default: true
#       - x509HostnameVerifier - optional - specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate
#                              - valid: strict,browser_compatible,allow_all - Default: allow_all
#       - keystore - optional - location of the KeyStore file - a URL or the local path to it. This input is empty if no HTTPS client authentication is used
#       - keystorePassword - optional - password associated with the KeyStore file
#       - trustKeystore - optional - location of the TrustStore file - a URL or the local path to it
#       - trustPassword - optional -  password associated with the TrustStore file
#   Outputs:
#       - return_result - response of the operation
#       - error_message: returnResult if statusCode different than '202'
#   Results:
#       - SUCCESS - operation succeeded (statusCode == '202')
#       - FAILURE - otherwise
####################################################

namespace: org.openscore.slang.base.network.rest

operation:
  name: http_client_get
  inputs:
    - url
    - username:
        required: false
    - password:
        required: false
    - authType:
        required: false
    - headers:
        required: false
    - method:
        default: "'get'"
        override: true
    - kerberosConfFile:
        default: "'0'"
    - socketTimeout:
        default: "'0'"
    - useCookies:
        default: "'true'"
    - followRedirects:
        default: "'false'"
    - proxy:
        required: false
    - proxyusername:
        required: false
    - proxyPassowrd:
        required: false
    - characterSet:
        default: "'UTF-8'"
    - trustAllRoots:
        default: "'true'"
    - x509HostnameVerifier:
        default: "'allow_all'"
    - keystore:
        required: false
    - keystorePassword:
        required: false
    - trustKeystore:
        required: false
    - trustPassword:
        required: false
  action:
    java_action:
      className: org.openscore.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - error_message: returnResult if returnCode != '0' else ''
  results:
    - SUCCESS : returnCode == '0'
    - FAILURE