####################################################
#!!
#! @description: Generated operation description
#!
#! @input project_id: Generated description
#! @input access_token: Generated description
#! @input network_name: Generated description
#! @input network_description: Generated description
#! @input auto_create_subnetworks: Generated description
#! @input ip_v_4_range: Generated description
#! @input proxy_host: Generated description
#! @input proxy_port: Generated description
#! @input proxy_username: Generated description
#! @input proxy_password: Generated description
#! @input pretty_print: Generated description
#!
#! @output return_code: Generated description
#! @output return_result: Generated description
#! @output exception: Generated description
#! @output zone_operation_name: Generated description
#!
#! @result SUCCESS: Generated description
#! @result FAILURE: Generated description
#!!#
####################################################

namespace: io.cloudslang.content.gcloud.actions.compute.networks
operation:
  name: insert_network
  inputs:
  - project_id:
      private: false
      sensitive: false
      required: true
  - projectId:
      default: ${get("project_id", "")}
      private: true
      sensitive: false
      required: false
  - access_token:
      private: false
      sensitive: true
      required: true
  - accessToken:
      default: ${get("access_token", "")}
      private: true
      sensitive: true
      required: false
  - network_name:
      private: false
      sensitive: false
      required: true
  - networkName:
      default: ${get("network_name", "")}
      private: true
      sensitive: false
      required: false
  - network_description:
      private: false
      sensitive: false
      required: false
  - networkDescription:
      default: ${get("network_description", "")}
      private: true
      sensitive: false
      required: false
  - auto_create_subnetworks:
      private: false
      sensitive: false
      required: false
  - autoCreateSubnetworks:
      default: ${get("auto_create_subnetworks", "")}
      private: true
      sensitive: false
      required: false
  - ip_v_4_range:
      private: false
      sensitive: false
      required: false
  - ipV4Range:
      default: ${get("ip_v_4_range", "")}
      private: true
      sensitive: false
      required: false
  - proxy_host:
      private: false
      sensitive: false
      required: false
  - proxyHost:
      default: ${get("proxy_host", "")}
      private: true
      sensitive: false
      required: false
  - proxy_port:
      private: false
      sensitive: false
      required: false
  - proxyPort:
      default: ${get("proxy_port", "")}
      private: true
      sensitive: false
      required: false
  - proxy_username:
      private: false
      sensitive: false
      required: false
  - proxyUsername:
      default: ${get("proxy_username", "")}
      private: true
      sensitive: false
      required: false
  - proxy_password:
      private: false
      sensitive: true
      required: false
  - proxyPassword:
      default: ${get("proxy_password", "")}
      private: true
      sensitive: true
      required: false
  - pretty_print:
      private: false
      sensitive: false
      required: false
  - prettyPrint:
      default: ${get("pretty_print", "")}
      private: true
      sensitive: false
      required: false
  java_action:
    method_name: execute
    gav: io.cloudslang.content:cs-google-cloud:0.0.1-SNAPSHOT
    class_name: io.cloudslang.content.gcloud.actions.compute.networks.NetworksInsert
  outputs:
  - return_code: ${returnCode}
  - return_result: ${returnResult}
  - exception: ${exception}
  - zone_operation_name: ${zoneOperationName}
  results:
  - FAILURE: ${returnCode=='-1'}
  - SUCCESS: ${returnCode=='0'}
