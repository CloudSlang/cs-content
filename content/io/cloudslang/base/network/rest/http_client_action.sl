#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Executes a REST call based on the method provided.
#
# Inputs:
#   - url - URL to which the call is made
#   - authType - optional - type of authentication used to execute the request on the target server - Valid: basic, form, springForm, digest, ntlm, kerberos, anonymous (no authentication) - Default: basic
#   - preemptiveAuth - optional - if 'true' authentication info will be sent in the first request, otherwise a request with no authentication info will be made and if server responds with 401 and a header like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info will be sent - Default: true
#   - username - optional - username used for URL authentication; for NTLM authentication, the required format is 'domain\user'
#   - password - optional - password used for URL authentication
#   - kerberosConfFile - optional - path to the Kerberos configuration file - Default: 0
#   - kerberosLoginConfFile - optional - login.conf file needed by the JAAS framework with the content similar to the one in examples - Format: http://docs.oracle.com/javase/7/docs/jre/api/security/jaas/spec/com/sun/security/auth/module/Krb5LoginModule.html
#   - kerberosSkipPortForLookup - optional - do not include port in the key distribution center database lookup - Default: true
#   - proxyHost - optional - proxy server used to access the web site
#   - proxyPort - optional - proxy server port - Default: 8080
#   - proxyUsername - optional - user name used when connecting to the proxy
#   - proxyPassword - optional - proxy server password associated with the <proxyUsername> input value
#   - trustAllRoots - optional - specifies whether to enable weak security over SSL - Default: true
#   - x509HostnameVerifier - optional - specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate - Valid: strict,browser_compatible,allow_all - Default: allow_all
#   - trustKeystore - optional - location of the TrustStore file - Format: a URL or the local path to it
#   - trustPassword - optional -  password associated with the TrustStore file
#   - keystore - optional - location of the KeyStore file - Format: a URL or the local path to it. This input is empty if no HTTPS client authentication is used
#   - keystorePassword - optional - password associated with the KeyStore file
#   - connectTimeout - optional - time to wait for a connection to be established, in seconds - Default: 0
#   - socketTimeout - optional - time to wait for data to be retrieved, in milliseconds - Default: 0
#   - useCookies - optional - specifies whether to enable cookie tracking or not - Default: true
#   - keepAlive - optional - specifies whether to create a shared connection that will be used in subsequent calls - Default: true
#   - connectionsMaxPerRoot - optional - maximum limit of connections on a per route basis - Default: 2
#   - connectionsMaxTotal - optional - maximum limit of connections in total - Default: 2
#   - headers - optional - list containing the headers to use for the request separated by new line (CRLF); header name - value pair will be separated by ":" - Format: According to HTTP standard for headers (RFC 2616) - Examples: Accept:text/plain
#   - responseCharacterSet - optional - character encoding to be used for the HTTP response - Default: ISO-8859-1
#   - destinationFile - optional - absolute path of a file on disk where the entity returned by the response will be saved to
#   - followRedirects -  specifies whether the 'Get' command automatically follows redirects - Default: true
#   - queryParams - optional - list containing query parameters to append to the URL - Examples: parameterName1=parameterValue1&parameterName2=parameterValue2;
#   - queryParamsAreURLEncoded - optional - whether to encode  (according to the url encoding standard) the queryParams - Default: false
#   - queryParamsAreFormEncoded - optional - whether to encode the queryParams in the form request format -  Default: true
#   - formParams - optional - input needs to be given in form encoded format and will set the entity to be sent in the request - Examples: input1=value1&input2=value2. (The client will send: input1=value1&in+put+2=val+u%0A+e2)
#   - formParamsAreURLEncoded - optional - formParams will be encoded  (according to the url encoding standard) if this is 'true' - Default: false
#   - sourceFile - optional - absolute path of a file on disk from where to read the entity for the http request; should not be provided for method=GET, HEAD, TRACE.
#   - body - optional - string to include in body for HTTP POST operation. If both sourceFile and body will be provided, the body input has priority over sourceFile; should not be provided for method=GET, HEAD, TRACE
#   - contentType - optional - content type that should be set in the request header, representing the MIME-type of the data in the message body - Default: text/plain
#   - requestCharacterSet - optional - character encoding to be used for the HTTP request body; should not be provided for method=GET, HEAD, TRACE - Default: ISO-8859-1
#   - multipartBodies - optional - list of name=textValue pairs separated by "&"; will also take into account the "contentType" and "charset" inputs
#   - multipartBodiesContentType - optional - each entity from the multipart entity has a content-type header; only specify once for all the parts. It is the only way to change the characterSet of the encoding - Default: text/plain; charset=ISO-8859-1
#   - multipartFiles - optional - list of name=filePath pairs
#   - multipartFilesContentType - optional - each entity from the multipart entity has a content-type header; only specify once for all parts - Default: application/octet-stream - Examples: image/png,text/plain
#   - multipartValuesAreURLEncoded - optional - set 'true' if the bodies may contain "&" and "=" - Default: false
#   - chunkedRequestEntity - optional - data is sent in a series of "chunks" - Valid: true/false
#   - method - HTTP method used
#   - httpClientCookieSession - optional - session object that holds the cookies if the useCookies input is true
#   - httpClientPoolingConnectionManager - optional - GlobalSessionObject that holds the http client pooling connection manager
# Outputs:
#   - return_result - response of the operation
#   - error_message - returnResult if statusCode different than '202'
#   - return_code - 0 if success, -1 otherwise
# Results:
#   - SUCCESS - operation succeeded (statusCode == '202')
#   - FAILURE - otherwise
################################################

namespace: io.cloudslang.base.network.rest

operation:
  name: http_client_action
  inputs:
    - url
    - authType:
        required: false
    - preemptiveAuth:
        default: "'true'"
    - username:
        required: false
    - password:
        required: false
    - kerberosConfFile:
        default: "'0'"
    - kerberosLoginConfFile:
        required: false
    - kerberosSkipPortForLookup:
        default: "'true'"
    - proxyHost:
        required: false
    - proxyPort:
        default: "'8080'"
        required: false
    - proxyUsername:
        required: false
    - proxyPassword:
        required: false
    - trustAllRoots:
        default: "'true'"
    - x509HostnameVerifier:
        default: "'allow_all'"
    - trustKeystore:
        required: false
    - trustPassword:
        required: false
    - keystore:
        required: false
    - keystorePassword:
        required: false
    - connectTimeout:
        default: "'0'"
    - socketTimeout:
        default: "'0'"
    - useCookies:
        default: "'true'"
    - keepAlive:
        default: "'true'"
    - connectionsMaxPerRoot:
        default: "'2'"
    - connectionsMaxTotal:
        default: "'2'"
    - headers:
        required: false
    - responseCharacterSet:
        default: "'ISO-8859-1'"
    - destinationFile:
        required: false
    - followRedirects:
        default: "'true'"
    - queryParams:
        required: false
    - queryParamsAreURLEncoded:
        default: "'false'"
    - queryParamsAreFormEncoded:
        default: "'true'"
    - formParams:
        required: false
    - formParamsAreURLEncoded:
        default: "'false'"
    - sourceFile:
        required: false
    - body:
        required: false
    - contentType:
        default: "'text/plain'"
    - requestCharacterSet:
        default: "'ISO-8859-1'"
    - multipartBodies:
        required: false
    - multipartBodiesContentType:
        default: "'text/plain; charset=ISO-8859-1'"
    - multipartFiles:
        required: false
    - multipartFilesContentType:
        default: "'application/octet-stream'"
    - multipartValuesAreURLEncoded:
        default: "'false'"
    - chunkedRequestEntity:
        required: false
    - method
    - httpClientCookieSession:
        required: false
    - httpClientPoolingConnectionManager:
        required: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - error_message: returnResult if returnCode != '0' else ''
    - return_code: returnCode
  results:
    - SUCCESS : returnCode == '0'
    - FAILURE