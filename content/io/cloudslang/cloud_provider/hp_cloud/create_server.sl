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
  name: create_server
  inputs:
    - host
    - port:
        default: "'443'"
    - token
    - tenant
    - server_name
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
    - img_ref
    - flavor_ref
    - keypair
    - network_id:
        required: false
    - network:
        default: >
          ', "networks" : [{"uuid": "' + network_id + '"}]' if network_id else ''
        overridable: false
    - headers:
        default: "'X-AUTH-TOKEN:' + token"
        overridable: false
    - url:
        default: "'https://' + host + ':' + port + '/v2/' + tenant + '/servers'"
        overridable: false
    - body:
        default: >
          '{"server": { "name": "' + server_name + '" , "imageRef": "' + img_ref +
          '", "flavorRef":"'+flavor_ref+'", "key_name":"'+keypair+'", "max_count":1, "min_count":1, "security_groups": [ {"name": "default"} ]' +
          network + '}}'
        overridable: false
    - contentType:
        default: "'application/json'"
        overridable: false
    - method:
        default: "'post'"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
    - error_message: returnResult if 'statusCode' not in locals() or statusCode != '202' else ''

  results:
    - SUCCESS: "'statusCode' in locals() and statusCode == '202'"
    - FAILURE