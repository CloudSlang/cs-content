namespace: io.cloudslang.amazon.aws.servicecatalog.products

imports:
  sc: io.cloudslang.amazon.aws.servicecatalog.products

flow:
  name: test_unprovision_product

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
    - connect_timeout:
        required: false
    - execution_timeout:
        required: false
    - async:
        required: false
    - provisioned_product_id:
        required: false
    - provisioned_product_name:
        required: false
    - accept_language:
        required: false
    - region:
        required: false
    - ignore_errors:
        required: false
    - terminate_token:
        required: false

  outputs:
  - return_result
  - exception

  workflow:
  - unprovision_product_success:
      do:
        sc.unprovision_product:
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
          - async
          - provisioned_product_id
          - provisioned_product_name
          - terminate_token
          - accept_language
          - region
          - ignore_errors
      publish:
      - return_result
      - return_code
      - exception
      navigate:
      - SUCCESS: SUCCESS
      - FAILURE: PROVISION_FAILURE

  results:
  - SUCCESS
  - PROVISION_FAILURE
