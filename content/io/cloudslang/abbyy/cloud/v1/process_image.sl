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
#! @description: Converts a given image to text in the specified output format using the ABBYY Cloud OCR REST API v1.
#!
#! @input location_id: The ID of the processing location to be used. Please note that the connection of your
#!                     application to the processing location is specified manually during application creation,
#!                     i.e. the application is bound to work with only one of the available locations.
#!                     Valid: 'cloud-eu', 'cloud-westus'.
#! @input application_id: The ID of the application to be used.
#! @input password: The password for the application
#! @input language: Optional - Specifies recognition language of the document. This parameter can contain several language
#!                             names separated with commas, for example "English,French,German".
#!                             Currently, the only official language supported by this operation is 'English'.
#!                  Valid: see the official ABBYY Cloud OCR SDK documentation.
#!                  Default: 'English'.
#! @input source_file: The absolute path of the image to be loaded and converted using the API.
#! @input destination_folder: Optional - The absolute path of a directory on disk where to save the entities returned by the response.
#!                                     For each export format selected a file will be created in the specified directory with name of
#!                                     'sourceFile' and corresponding extension (e.g. for exportFormat='xml,txt' and sourceFile='source.jpg'
#!                                     the files 'source.xml' and 'source.txt' will be created). If one of files already exists then an
#!                                     exception will be thrown.
#!                            Default: ''.
#!                            Note: This capability is provided “as is”, please see product documentation for further information.
#! @input text_type: Optional - Specifies the type of the text on a page.
#!                              This parameter may also contain several text types separated with commas, for example "normal,matrix".
#!                   Valid: 'normal', 'typewriter', 'matrix', 'index', 'ocrA', 'ocrB', 'e13b', 'cmc7', 'gothic'.
#!                   Default: 'normal'.
#! @input image_source: Optional - Specifies the source of the image. It can be either a scanned image, or a photograph created
#!                                 with a digital camera. Special preprocessing operations can be performed with the image depending
#!                                 on the selected source. For example, the system can automatically correct distorted text lines,
#!                                 poor focus and lighting on photos.
#!                      Valid: 'auto', 'photo', 'scanner'.
#!                      Default: 'auto'.
#! @input correct_orientation: Optional - Specifies whether the orientation of the image should be automatically detected and corrected.
#!                             Valid: 'true', 'false'.
#!                             Default: 'true'.
#! @input correct_skew: Optional - Specifies whether the skew of the image should be automatically detected and corrected.
#!                      Valid: 'true', 'false'.
#!                      Default: 'true'.
#! @input export_format: Optional - Specifies the export format.
#!                                 This parameter can contain up to three export formats, separated with commas (example: "pdfSearchable,txt,xml").
#!                      Valid: 'txt', 'pdfSearchable', 'xml'.
#!                      Default: 'xml'.
#! @input description: Optional - Contains the description of the processing task. Cannot contain more than 255 characters.
#!                                If the description contains more than 255 characters, then the text will be truncated.
#!                     Default: ''.
#! @input pdf_password: Optional - Contains a password for accessing password-protected images in PDF format.
#!                      Default: ''.
#! @input proxy_host: Optional - The proxy server used to access the web site.
#! @input proxy_port: Optional - The proxy server port. The value '-1' indicates that the proxy port is not set
#!                               and the scheme default port will be used, e.g. if the scheme is 'http://' and
#!                               the 'proxyPort' is set to '-1' then port '80' will be used.
#!                    Valid: -1 and integer values greater than 0.
#!                    Default: 8080
#! @input proxy_username: Optional - The user name used when connecting to the proxy.
#! @input proxy_password: Optional - The proxy server password associated with the proxy_username input value.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL/TSL. A certificate is trusted
#!                                    even if no trusted certification authority issued it.
#!                         Valid: 'true', 'false'.
#!                         Default: 'false'.
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's Common Name (CN)
#!                                            or subjectAltName field of the X.509 certificate. Set this to "allow_all" to skip any checking.
#!                                            For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox.
#!                                            The hostname must match either the first CN, or any of the subject-alts.
#!                                            A wildcard can occur in the CN, and in any of the subject-alts. The only difference
#!                                            between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com")
#!                                            with "browser_compatible" matches all subdomains, including "a.b.foo.com".
#!                                 Valid: 'strict','browser_compatible','allow_all'.
#!                                 Default: 'strict'.
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from other parties
#!                                   that you expect to communicate with, or from Certificate Authorities that you trust to
#!                                   identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                                   trustAllRoots is 'true' this input is ignored.
#!                        Default: <OO_Home>/java/lib/security/cacerts. Format: Java KeyStore (JKS)
#! @input trust_password: Optional - The password associated with the TrustStore file.
#!                                   If trustAllRoots is 'false' and trustKeystore is empty, trustPassword default will be supplied.
#! @input connect_timeout: Optional - The time to wait for a connection to be established, in seconds.
#!                                    A timeout value of '0' represents an infinite timeout.
#!                         Default: '0'.
#! @input socket_timeout: Optional - The timeout for waiting for data (a maximum period inactivity between two consecutive data packets),
#!                                   in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Default: '0'.
#! @input keep_alive: Optional - Specifies whether to create a shared connection that will be used in subsequent calls.
#!                               If keepAlive is 'false', the already open connection will be used and after execution it will close it.
#!                               The operation will use a connection pool stored in a GlobalSessionObject that will be available throughout
#!                               the execution (the flow and subflows, between parallel split lanes).
#!                    Valid: 'true', 'false'.
#!                    Default: 'true'.
#! @input connections_max_per_route: Optional - The maximum limit of connections on a per route basis.
#!                                              The default will create no more than 2 concurrent connections per given route.
#!                                   Default: '2'.
#! @input connections_max_total: Optional - The maximum limit of connections in total.
#!                                          The default will create no more than 2 concurrent connections in total.
#!                               Default: '20'.
#! @input response_character_set: Optional - The character encoding to be used for the HTTP response.
#!                                           If responseCharacterSet is empty, the charset from the 'Content-Type' HTTP response header will be used.
#!                                           If responseCharacterSet is empty and the charset from the HTTP response Content-Type header is empty,
#!                                           the default value will be used.
#!                                Default: 'UTF-8'.
#!
#! @output return_result: Contains a human readable message mentioning the success or failure of the task.
#! @output txt_result: The result for 'txt' export format in clear text (empty if 'txt' was not provided in 'exportFormat' input).
#!                     Some characters will be escaped in order to avoid code injection.
#!                     For the unescaped version of the result use the destination_file input.
#! @output xml_result: The result for 'xml' export format in clear text (empty if 'xml' was not provided in 'exportFormat' input).
#!                     Some characters will be escaped in order to avoid code injection.
#!                     For the unescaped version of the result use the destination_folder input.
#! @output pdf_url: The URL at which the PDF result of the recognition process can be found
#!                  (empty if 'pdfSearchable' was not provided in 'exportFormat' input).
#! @output task_id: The ID of the task registered in the ABBYY server.
#! @output credits: The amount of ABBYY credits spent on the action.
#! @output result_url: The URL at which the result of the recognition process can be found.
#! @output status_code: The status_code returned by the server.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output exception: The exception message and stack trace if the operation goes to failure.
#! @output timed_out: True if the operation timed out before the document was processed, false otherwise.
#!
#! @result SUCCESS: Operation succeeded.
#! @result FAILURE: Operation failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.abbyy.cloud.v1

operation:
  name: process_image

  inputs:
    - location_id
    - locationId:
        default: ${get("location_id","")}
        private: true
    - application_id
    - applicationId:
        default: ${get("application_id", "")}
        private: true
    - password:
        sensitive: true
    - language:
        default: 'English'
        required: false
    - source_file
    - sourceFile:
        default: ${get("source_file", "")}
        private: true
    - destination_folder:
        required: false
    - destinationFolder:
        default: ${get("destination_folder", "")}
        required: false
        private: true
    - text_type:
        default: 'normal'
        required: false
    - textType:
        default: ${get("text_type", "")}
        required: false
        private: true
    - image_source:
        default: 'auto'
        required: false
    - imageSource:
        default: ${get("image_source", "")}
        required: false
        private: true
    - correct_orientation:
        default: 'true'
        required: false
    - correctOrientation:
        default: ${get("correct_orientation", "")}
        required: false
        private: true
    - correct_skew:
        default: 'true'
        required: false
    - correctSkew:
        default: ${get("correct_skew", "")}
        required: false
        private: true
    - export_format:
        default: 'xml'
        required: false
    - exportFormat:
        default: ${get("export_format", "")}
        required: false
        private: true
    - description:
        required: false
    - pdf_password:
        required: false
        sensitive: true
    - pdfPassword:
        default: ${get("pdf_password", "")}
        required: false
        sensitive: true
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        default: '8080'
        required: false
    - proxyPort:
        default: ${get("proxy_port", "")}
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - trustAllRoots:
        default: ${get("trust_all_roots", "")}
        private: true
    - x_509_hostname_verifier:
        default: 'strict'
        required: false
    - x509HostnameVerifier:
        default: ${get("x_509_hostname_verifier", "")}
        private: true
    - trust_keystore:
        required: false
    - trustKeystore:
        default: ${get("trust_keystore", "")}
        required: false
        private: true
    - trust_password:
        required: false
        sensitive: true
    - trustPassword:
        default: ${get("trust_password", "")}
        required: false
        private: true
        sensitive: true
    - connect_timeout:
        default: '0'
        required: false
    - connectTimeout:
        default: ${get("connect_timeout", "")}
        required: false
        private: true
    - socket_timeout:
        default: '0'
        required: false
    - socketTimeout:
        default: ${get("socket_timeout", "")}
        private: true
    - keep_alive:
        default: 'true'
        required: false
    - keepAlive:
        default: ${get("keep_alive", "")}
        private: true
    - connections_max_per_route:
        default: '2'
        required: false
    - connectionsMaxPerRoute:
        default: ${get("connections_max_per_route", "")}
        private: true
    - connections_max_total:
        default: '20'
        required: false
    - connectionsMaxTotal:
        default: ${get("connections_max_total", "")}
        private: true
    - response_character_set:
        default: 'UTF-8'
        required: false
    - responseCharacterSet:
        default: ${get("response_character_set", "")}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-abbyy:0.0.5'
    class_name: io.cloudslang.content.abbyy.actions.ProcessImageAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - txt_result: ${get("txtResult", "")}
    - xml_result: ${get("xmlResult", "")}
    - pdf_url: ${get("pdfUrl", "")}
    - task_id: ${taskId}
    - credits
    - status_code: ${statusCode}
    - return_code: ${returnCode}
    - exception
    - timed_out: ${timedOut}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE