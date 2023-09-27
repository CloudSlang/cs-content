########################################################################################################################
#!!
#! @description: This workflow resizes the aws instance to the given target size.
#!
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: Secret access key associated with your Amazon AWS account.
#! @input region: The region where the instance is deployed. To select a specific region, you either mention the
#!                endpoint corresponding to that region or provide a value to region input. In case both serviceEndpoint
#!                and region are specified, the serviceEndpoint will be used and region will be ignored.
#!                Examples: us-east-1, us-east-2, us-west-1, us-west-2, ca-central-1, eu-west-1, eu-central-1,
#!                eu-west-2,ap-northeast-1, ap-northeast-2, ap-southeast-1, ap-southeast-2, ap-south-1, sa-east-1
#! @input instance_id: The ID of the instance to be resized.
#! @input proxy_host: The proxy server used to access the provider services.
#!                    Optional
#! @input proxy_port: The proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: The proxy server user name.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '10'
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: '60'
#!                         Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input instance_type: Instance type. For more information, see Instance Types in the Amazon Elastic Compute Cloud
#!                       User Guide.
#!                       Valid values: t1.micro | t2.nano | t2.micro | t2.small | t2.medium | t2.large | m1.small |
#!                       m1.medium | m1.large | m1.xlarge | m3.medium | m3.large | m3.xlarge | m3.2xlarge |
#!                       m4.large | m4.xlarge | m4.2xlarge | m4.4xlarge | m4.10xlarge | m2.xlarge |
#!                       m2.2xlarge | m2.4xlarge | cr1.8xlarge | r3.large | r3.xlarge | r3.2xlarge |
#!                       r3.4xlarge | r3.8xlarge | x1.4xlarge | x1.8xlarge | x1.16xlarge | x1.32xlarge |
#!                       i2.xlarge | i2.2xlarge | i2.4xlarge | i2.8xlarge | hi1.4xlarge | hs1.8xlarge |
#!                       c1.medium | c1.xlarge | c3.large | c3.xlarge | c3.2xlarge | c3.4xlarge | c3.8xlarge |
#!                       c4.large | c4.xlarge | c4.2xlarge | c4.4xlarge | c4.8xlarge | cc1.4xlarge |
#!                       cc2.8xlarge | g2.2xlarge | g2.8xlarge | cg1.4xlarge | d2.xlarge | d2.2xlarge |
#!                       d2.4xlarge | d2.8xlarge
#!                       Default: 't2.micro'
#!                       Optional
#!
#! @output return_result: Contains the instance details in case of success, error message otherwise.
#!
#! @result FAILURE: There was an error while trying to resize the instance.
#! @result SUCCESS: The instance was successfully resized.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2
flow:
  name: aws_resize_instance_workflow
  inputs:
    - access_key_id
    - access_key:
        sensitive: true
    - region
    - instance_id
    - worker_group:
        default: RAS_Operator_Path
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - polling_interval:
        default: '10'
        required: false
    - polling_retries:
        default: '60'
        required: false
    - target_instance_type
  workflow:
    - set_endpoint:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - region: '${region}'
        publish:
          - provider_sap: '${".".join(("https://ec2",region, "amazonaws.com"))}'
        navigate:
          - SUCCESS: describe_instances
          - FAILURE: on_failure
    - modify_instance_attribute:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.modify_instance_attribute:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - instance_id: '${instance_id}'
            - instance_type: '${target_instance_type}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: describe_instance
          - FAILURE: on_failure
    - check_instance_state_v2:
        worker_group:
          value: '${worker_group}'
          override: true
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            io.cloudslang.amazon.aws.ec2.instances.check_instance_state_v2:
              - provider_sap: '${provider_sap}'
              - access_key_id: '${access_key_id}'
              - access_key:
                  value: '${access_key}'
                  sensitive: true
              - instance_id: '${instance_id}'
              - instance_state: '${original_instance_state}'
              - proxy_host: '${proxy_host}'
              - proxy_port: '${proxy_port}'
              - proxy_username: '${proxy_username}'
              - proxy_password:
                  value: '${proxy_password}'
                  sensitive: true
              - polling_interval: '${polling_interval}'
              - worker_group: '${worker_group}'
          break:
            - SUCCESS
          publish:
            - return_result
            - return_code
            - exception
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - describe_instances:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.describe_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - instance_ids_string: '${instance_id}'
        publish:
          - instance_details: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: parse_state_to_get_instance_status
          - FAILURE: on_failure
    - parse_state_to_get_instance_status:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${instance_details}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='instanceState']/*[local-name()='name']"
            - query_type: value
        publish:
          - original_instance_state: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: check_if_instance_is_in_stopped_state
          - FAILURE: on_failure
    - check_if_instance_is_in_stopped_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${original_instance_state}'
            - second_string: stopped
        navigate:
          - SUCCESS: modify_instance_attribute
          - FAILURE: aws_stop_instance_v2
    - aws_stop_instance_v2:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.amazon.aws.ec2.aws_stop_instance_v2:
            - provider_sap: '${provider_sap}'
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - instance_id: '${instance_id}'
            - region: '${region}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - polling_interval: '${polling_interval}'
            - polling_retries: '${polling_retries}'
            - worker_group: '${worker_group}'
        navigate:
          - SUCCESS: modify_instance_attribute
          - FAILURE: on_failure
    - check_if_original_instance_state_is_stopped:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${original_instance_state}'
            - second_string: stopped
        navigate:
          - SUCCESS: check_instance_state_v2
          - FAILURE: aws_start_instance_v2
    - aws_start_instance_v2:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.amazon.aws.ec2.aws_start_instance_v2:
            - provider_sap: '${provider_sap}'
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - region: '${region}'
            - instance_id: '${instance_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - polling_interval: '${polling_interval}'
            - polling_retries: '${polling_retries}'
            - worker_group: '${worker_group}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - parse_details_to_get_instance_type:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${instance_details}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='instanceType']"
            - query_type: value
        publish:
          - instance_type: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: check_if_instance_type_is_changed
          - FAILURE: on_failure
    - describe_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.describe_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - instance_ids_string: '${instance_id}'
        publish:
          - instance_details: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: parse_details_to_get_instance_type
          - FAILURE: on_failure
    - check_if_instance_type_is_changed:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_type}'
            - second_string: '${target_instance_type}'
        navigate:
          - SUCCESS: check_if_original_instance_state_is_stopped
          - FAILURE: on_failure
  outputs:
    - return_result
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      parse_details_to_get_instance_type:
        x: 920
        'y': 440
      check_if_instance_type_is_changed:
        x: 920
        'y': 200
      aws_start_instance_v2:
        x: 1160
        'y': 440
        navigate:
          1d221fd1-8333-e8b6-dab9-d94bfb07e913:
            targetId: 4402ff28-68e3-5ec9-bfe0-6be49c5e77bd
            port: SUCCESS
      parse_state_to_get_instance_status:
        x: 400
        'y': 200
      describe_instance:
        x: 720
        'y': 440
      describe_instances:
        x: 240
        'y': 200
      aws_stop_instance_v2:
        x: 520
        'y': 440
      check_if_original_instance_state_is_stopped:
        x: 1160
        'y': 200
      set_endpoint:
        x: 80
        'y': 200
      modify_instance_attribute:
        x: 720
        'y': 200
      check_if_instance_is_in_stopped_state:
        x: 520
        'y': 200
      check_instance_state_v2:
        x: 1440
        'y': 200
        navigate:
          7c364a51-e04f-4de1-1731-4254d1c3f9a8:
            targetId: 4402ff28-68e3-5ec9-bfe0-6be49c5e77bd
            port: SUCCESS
    results:
      SUCCESS:
        4402ff28-68e3-5ec9-bfe0-6be49c5e77bd:
          x: 1440
          'y': 440

