namespace: io.cloudslang.amazon.aws.servicecatalog.products

imports:
  sc: io.cloudslang.amazon.aws.servicecatalog.products
  lists: io.cloudslang.base.lists

flow:
  name: test_provision_product

  inputs:
    - identity
    - credential:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
    - execution_timeout:
        required: false
    - polling_interval:
        required: false
    - async:
        required: false
    - provisioning_parameters:
        required: false
    - product_id
    - provisioned_product_name
    - provisioning_artifact_id
    - delimiter:
        required: false
    - tags:
        required: false
    - provision_token:
        required: false
    - accept_language:
        required: false
    - notification_arns:
        required: false
    - path_id:
        required: false
    - region:
        required: false

  outputs:
    - return_result
    - exception

  workflow:
    - provision_product_success:
        do:
          sc.provision_product:
            - identity
            - credential:
                sensitive: true
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password:
                sensitive: true
            - connect_timeout
            - execution_timeout
            - polling_interval
            - async
            - provisioning_parameters
            - product_id
            - provisioned_product_name
            - provisioning_artifact_id
            - delimiter
            - tags
            - provision_token
            - accept_language
            - notification_arns
            - path_id
            - region
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: PROVISION_FAILURE

    - check_result:
        do:
          lists.compare_lists:
           - list_1: ${str(exception) + "," + return_code}
           - list_2: ",0"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULT_FAILURE

  results:
    - SUCCESS
    - PROVISION_FAILURE
    - CHECK_RESULT_FAILURE
