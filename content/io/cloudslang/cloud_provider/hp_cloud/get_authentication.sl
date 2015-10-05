####################################################
#
# OpenStack content for HP Helion Public Cloud
# Modified from io.cloudslang.openstack (v0.8) content
#
# Ben Coleman, Sept 2015
# v0.1
#
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud

operation:
  name: get_authentication
  inputs:
    - host
    - identity_port:
        default: "'35357'"
    - username
    - password
    - tenant_name
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxyHost:
        default: "proxy_host if proxy_host is not None else ''"
        overridable: false
    - proxyPort:
        default: "proxy_port if proxy_port is not None else ''"
        overridable: false
    - url:
        default: "'https://'+ host + ':' + identity_port + '/v2.0/tokens'"
        overridable: false
    - body:
        default: >
          '{"auth": {"tenantName": "' + tenant_name +
          '","passwordCredentials": {"username": "' + username +
          '", "password": "' + password + '"}}}'
        overridable: false
    - method:
        default: "'post'"
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
    - return_code: returnCode
    - error_message: returnResult if returnCode == '-1' or statusCode != 200 else ''
  results:
    - SUCCESS: "'statusCode' in locals() and returnCode != '-1' and statusCode == '200'"
    - FAILURE