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
#! @description: This operation creates a new bucket with provided name or edit specified bucket if already exist.
#!               'https://developer.couchbase.com/documentation/server/4.6/rest-api/rest-bucket-create.html'
#!
#! @input endpoint: Endpoint to which request will be sent.
#!                  A valid endpoint will be formatted as it shows in the example.
#!                  Example: "http://somewhere.couchbase.com:8091"
#! @input username: Username used in basic authentication.
#! @input password: Password associated with "username" input to be used in basic authentication.
#! @input proxy_host: Proxy server used to connect to Couchbase API. If empty no proxy will be used.
#!                    Optional
#! @input proxy_port: Proxy server port. You must either specify values for both proxy_host
#!                    and proxy_port inputs or leave them both empty.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL.
#!                         A certificate is trusted even if no trusted certification authority issued it.
#!                         Valid: 'true', 'false'
#!                         Default: 'true'
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the
#!                                 subject's Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Set this to "allow_all" to skip any checking. For the value "browser_compatible"
#!                                 the hostname verifier works the same way as Curl and Firefox. The hostname must
#!                                 match either the first CN, or any of the subject-alts. A wildcard can occur in
#!                                 the CN, and in any of the subject-alts. The only difference between
#!                                 "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com")
#!                                 with "browser_compatible" matches all subdomains, including "a.b.foo.com".
#!                                 Valid values: "strict", "browser_compatible", "allow_all"
#!                                 Default value: "allow_all"
#!                                 Optional
#! @input trust_keystore: Pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities
#!                        that you trust to identify other parties. If the protocol (specified by the "url")
#!                        is not "https" or if trustAllRoots is "true" this input is ignored.
#!                        Default: '../java/lib/security/cacerts'
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: Password associated with the TrustStore file. If trust_all_roots is
#!                        'false' and trustKeystore is empty, trustPassword default will be supplied.
#!                        Default: 'changeit'
#!                        Optional
#! @input keystore: Pathname of the Java KeyStore file. You only need this if the server
#!                  requires client authentication. If the protocol (specified by the 'url') is not
#!                  'https' or if trust_all_roots is 'true' this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Default: '../java/lib/security/cacerts.'
#!                  Optional
#! @input keystore_password: Password associated with the KeyStore file. If trust_all_roots is 'false'
#!                           and keystore is empty, keystorePassword default will be supplied.
#!                           Default: 'changeit'
#!                           Optional
#! @input connect_timeout: Time to wait for a connection to be established, in seconds. A timeout
#!                         value of '0' represents an infinite timeout.
#!                         Default: '0'
#!                         Optional
#! @input socket_timeout: Timeout for waiting for data (a maximum period inactivity between two
#!                        consecutive data packets), in seconds. A socket_timeout value of '0' represents
#!                        an infinite timeout.
#!                        Default: '0'
#!                        Optional
#! @input use_cookies: Specifies whether to enable cookie tracking or not. Cookies are stored
#!                     between consecutive calls in a serializable session object therefore they will
#!                     be available on a branch level. If you specify a non-boolean value, the default
#!                     value is used.
#!                     Valid: 'true', 'false'
#!                     Default: 'true'
#!                     Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in
#!                    subsequent calls. If keepAlive is 'false', the already open connection will be
#!                    used and after execution it will close it.
#!                    Valid: 'true', 'false'
#!                    Default: 'true'
#!                    Optional
#! @input bucket_name: Name of the bucket to be created/edited
#! @input auth_type: Type of authorization to be enabled for the new bucket. Defaults to
#!                   blank password if not specified. 'sasl' enables authentication, 'none' disables
#!                   authentication.
#!                   Valid: 'none', 'sasl'
#!                   Default: 'none'
#! @input bucket_type: Type of bucket to be created. 'memcached' configures as Memcached
#!                     Note: bucket_type value cannot be changed for a pre-existing bucket.
#!                     bucket, 'couchbase' configures as Couchbase bucket.
#!                     Valid: 'couchbase', 'memcached'
#!                     Default: 'memcached'
#! @input conflict_resolution_type: 'lww' means timestamp-based conflict resolution, 'seqno' means revision
#!                                  ID-based conflict resolution.
#!                                  Valid: 'lww', 'seqno'
#!                                  Default: 'seqno'
#!                                  Note: conflictResolutionType value cannot be changed once a bucket has been created.
#! @input couchbase_proxy_port: Proxy port on which the bucket communicates. Must be a valid network
#!                              port which is not already in use. You must provide a valid port number if the
#!                              authorization type is not 'sasl'.
#! @input eviction_policy: Parameter that determines what is ejected: only the value or the key,
#!                         value, and all metadata.
#!                         Valid: 'fullEviction', 'valueOnly'
#!                         Default: 'valueOnly'
#!                         Note: If you change the ejection policy of a pre-existing bucket then it will
#!                         be restarted, resulting in temporary inaccessibility of data while the bucket
#!                         warms up.
#! @input flush_enabled: Enables/disables the 'flush all' functionality of the bucket.
#!                       Valid: 'true', 'false'
#!                       Default: 'false'
#! @input parallel_db_and_view_compaction: Indicates whether database and view files on disk can be compacted
#!                                         simultaneously.
#!                                         Valid: 'true', 'false'
#!                                         Default: 'false'
#!                                         Optional
#! @input ram_quota_mb: RAM Quota for new bucket in MB. Minimum you can specify is 100, and
#!                       the maximum can only be as great as the memory quota established for the node.
#!                       If other buckets are associated with a node, RAM Quota can only be as large as
#!                       the amount memory remaining for the node, accounting for the other bucket memory
#!                       quota.
#!                       Default: '100'
#!                       Optional
#! @input replica_index: Enables/disables replica indexes for replica bucket data
#!                       Note: replicaIndex value cannot be changed for a pre-existing bucket.
#!                       Valid: 'true', 'false'
#!                       Default: 'true'
#!                       Optional
#! @input replica_number: Number of replicas to be configured for this bucket. Required parameter
#!                        when creating a Couchbase bucket.
#!                        Valid: '0', '1', '2', '3'
#!                        Default: '1'
#!                        Optional
#! @input sasl_password: Password for SASL authentication. Required if SASL authentication has been enabled.
#!                       Optional
#! @input threads_number: Change the number of concurrent readers and writers for the data bucket.
#!                        Note: If you change this setting for a pre-existing bucket then it will be restarted,
#!                        resulting in temporary inaccessibility of data while the bucket warms up.
#!                        Valid: '2', '3', '4', '5', '6', '7', '8'
#!                        Default: '2'
#!                        Optional
#!
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output return_result: A map with strings as keys and strings as values that contains information about the created
#!                        or edited bucket.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The Couchbase bucket was created or edited successfully.
#! @result FAILURE: An error occurred while trying to create or edit the Couchbase bucket.
#!!#
########################################################################################################################

namespace: io.cloudslang.couchbase.buckets

operation: 
  name: create_or_edit_bucket
  
  inputs: 
    - endpoint    
    - username    
    - password:    
        sensitive: true
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:
        default: '8080'
        required: false  
    - proxyPort: 
        default: ${get('proxy_port', '')}  
        required: false 
        private: true 
    - proxy_username:  
        required: false  
    - proxyUsername: 
        default: ${get('proxy_username', '')}  
        required: false 
        private: true 
    - proxy_password:  
        required: false  
        sensitive: true
    - proxyPassword: 
        default: ${get('proxy_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - trust_all_roots:
        default: 'true'
        required: false  
    - trustAllRoots: 
        default: ${get('trust_all_roots', '')}  
        required: false 
        private: true 
    - x_509_hostname_verifier:
        default: 'allow_all'
        required: false  
    - x509HostnameVerifier: 
        default: ${get('x_509_hostname_verifier', '')}  
        required: false 
        private: true 
    - trust_keystore:  
        required: false  
    - trustKeystore: 
        default: ${get('trust_keystore', '')}  
        required: false 
        private: true 
    - trust_password:
        default: 'changeit'
        required: false  
        sensitive: true
    - trustPassword: 
        default: ${get('trust_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - keystore:  
        required: false  
    - keystore_password:
        default: 'changeit'
        required: false  
        sensitive: true
    - keystorePassword: 
        default: ${get('keystore_password', '')}  
        required: false 
        private: true 
        sensitive: true
    - connect_timeout:
        default: '0'
        required: false  
    - connectTimeout: 
        default: ${get('connect_timeout', '')}  
        required: false 
        private: true 
    - socket_timeout:
        default: '0'
        required: false  
    - socketTimeout: 
        default: ${get('socket_timeout', '')}  
        required: false 
        private: true 
    - use_cookies:
        default: 'true'
        required: false  
    - useCookies: 
        default: ${get('use_cookies', '')}  
        required: false 
        private: true 
    - keep_alive:
        default: 'true'
        required: false  
    - keepAlive: 
        default: ${get('keep_alive', '')}  
        required: false 
        private: true 
    - bucket_name    
    - bucketName: 
        default: ${get('bucket_name', '')}  
        required: false 
        private: true 
    - auth_type:
        default: 'none'
        required: false  
    - authType: 
        default: ${get('auth_type', '')}  
        required: false 
        private: true 
    - bucket_type:
        default: 'memcached'
        required: false  
    - bucketType: 
        default: ${get('bucket_type', '')}  
        required: false 
        private: true 
    - conflict_resolution_type:
        default: 'seqno'
        required: false  
    - conflictResolutionType: 
        default: ${get('conflict_resolution_type', '')}  
        required: false 
        private: true 
    - couchbase_proxy_port:  
        required: false  
    - couchbaseProxyPort: 
        default: ${get('couchbase_proxy_port', '')}  
        required: false 
        private: true 
    - eviction_policy:
        default: 'valueOnly'
        required: false  
    - evictionPolicy: 
        default: ${get('eviction_policy', '')}  
        required: false 
        private: true 
    - flush_enabled:
        default: 'false'
        required: false  
    - flushEnabled: 
        default: ${get('flush_enabled', '')}  
        required: false 
        private: true 
    - parallel_db_and_view_compaction:
        default: 'false'
        required: false  
    - parallelDBAndViewCompaction: 
        default: ${get('parallel_db_and_view_compaction', '')}  
        required: false 
        private: true 
    - ram_quota_mb:
        default: '100'
        required: false  
    - ramQuotaMB: 
        default: ${get('ram_quota_mb', '')}  
        required: false 
        private: true 
    - replica_index:
        required: 'true'
        required: false  
    - replicaIndex: 
        default: ${get('replica_index', '')}  
        required: false 
        private: true 
    - replica_number:
        default: '1'
        required: false  
    - replicaNumber: 
        default: ${get('replica_number', '')}  
        required: false 
        private: true 
    - sasl_password:  
        required: false  
    - saslPassword: 
        default: ${get('sasl_password', '')}  
        required: false 
        private: true 
    - threads_number:
        default: '2'
        required: false  
    - threadsNumber: 
        default: ${get('threads_number', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-couchbase:0.1.0'
    class_name: 'io.cloudslang.content.couchbase.actions.buckets.CreateOrEditBucket'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${returnCode} 
    - return_result: ${returnResult} 
    - exception: ${exception} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
