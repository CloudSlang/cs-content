namespace: io.cloudslang.openshift

operation:
  name: delete_app
  inputs:
    - applicationId:
        required: true
    - host:
        required: true
    - username:
        required: true
    - password:
        required: true
    - domain:
        required: true
    - url:
        default: "'https://' + host + '/broker/rest/application/' + applicationId"
        overridable: false
    - headers:
        default: "'Accept: application/json'"
        overridable: false
    - trustAllRoots:
        default: "'true'"
    - method:
        default: "'delete'"
        overridable: false
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
    - timeout:
        default: "120"
        overridable: false
  action:
    java_action:
      className: io.cloudslang.content.httpclient.HttpClientAction
      methodName: execute
  outputs:
    - return_result: returnResult
    - status_code: "'' if 'statusCode' not in locals() else statusCode"
    - error_message: returnResult if 'statusCode' not in locals() or statusCode != '201' else ''

  results:
    - SUCCESS: "'statusCode' in locals() and statusCode == '201'"
    - FAILURE