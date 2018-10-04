namespace: io.cloudslang.amazon.aws.servicecatalog.products

imports:
  sc: io.cloudslang.amazon.aws.servicecatalog.products

flow:
  name: test_update_provisioned_product

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
    - async:
        required: false
    - region:
        required: false
    - accepted_language:
        required: false
    - path_id:
        required: false
    - product_id:
        required: false
    - provisioned_product_id:
        required: false
    - provisioned_product_name:
        required: false
    - provisioning_artifact_id:
        required: false
    - provisioning_parameters:
        required: false
    - use_previous_value:
        required: false
    - delimiter:
        required: false
    - update_token:
        required: false

  outputs:
  - return_result
  - exception

  workflow:
  - update_provisioned_product_success:
      do:
        sc.update_provisioned_product:
          - identity
          - credential:
              value: '${credential}'
              sensitive: true
          - proxy_host
          - proxy_port
          - proxy_username
          - proxy_password:
              sensitive: true
          - connect_timeout
          - execution_timeout
          - async
          - region
          - accepted_language
          - path_id
          - product_id
          - provisioned_product_id
          - provisioned_product_name
          - provisioning_artifact_id
          - provisioning_parameters
          - use_previous_value
          - delimiter
          - update_token
      publish:
      - return_result
      - return_code
      - exception
      navigate:
      - SUCCESS: SUCCESS
      - FAILURE: UPDATE_PROVISIONED_PRODUCT_FAILURE

  results:
  - SUCCESS
  - UPDATE_PROVISIONED_PRODUCT_FAILURE

