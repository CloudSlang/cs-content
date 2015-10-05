####################################################
#
# OpenStack content for HP Helion Public Cloud
# Modified from io.cloudslang.openstack (v0.8) content
#
# Ben Coleman, Sept 2015
# v0.1
#
####################################################

namespace: io.cloudslang.cloud_provider.hp_cloud.net

operation:
  name: delete_floating_ip
  inputs:
    - host
    - port:
        default: "'443'"
    - token
    - ip_id
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxyHost:
        default: "proxy_host if proxy_host else ''"
        overridable: false
    - proxyPort:
        default: "proxy_port if proxy_port else ''"
        overridable: false
    - headers:
        default: "'X-AUTH-TOKEN:' + token"
        overridable: false
    - url:
        default: "'https://' + host + ':' + port + '/v2.0/floatingips/' + ip_id"
        overridable: false
    - body:
        default: "''"
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
    - method:
        default: "'delete'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    #- return_result: returnResult
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
    #- error_message: returnResult if 'statusCode' not in locals() or statusCode != '200' else ''

  results:
    - SUCCESS:  "'statusCode' in locals() and statusCode == '204'"
    - FAILURE