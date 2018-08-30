########################################################################################################################
#!!
#! @description: This operation generate UUID by version, using a variable as an input
#!
#! @input version: UUID Version which will be generated.
#!                 Notes:
#!                 1. These are 4 different versions for variant 2 UUIDs: "1" Time Based (UUIDv1),
#!                    "3", "5" Name Based (UUIDv3 and UUIDv5), "4" Random (UUIDv4).
#!                 2. The only difference between UUIDv3 and UUIDv5 is the Hashing Algorithm – v3 uses MD5 (128 bits)
#!                    while v5 uses SHA-1 (160 bits), using v5 is recommended.
#!				   3. The UUID v4 implementation uses random numbers as the source. The Java implementation is
#!                    SecureRandom –which uses an unpredictable value as the seed to generate random numbers to reduce
#!                    the chance of collisions.
#!                 Valid values: '1', '3', '4', '5'
#!                 Default: '1'
#! @input name: A variable used to generate UUID Version 2.
#!              Optional
#!
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output return_result: This will contain the UUID.
#! @output exception: In case of success response, this result is empty. In case of failure response, this result
#!                    contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: An error occurred during execution.
#!!#
########################################################################################################################
namespace: io.cloudslang.base.utils

operation:
  name: uuid_generator

  inputs:
    - version:
        default: '1'
        required: false
    - name:
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-utilities:0.1.5-SNAPSHOT'
    class_name: 'io.cloudslang.content.utilities.actions.UUIDGenerator'
    method_name: 'execute'

  outputs:
    - return_code: ${get('returnCode', '')}
    - return_result: ${get('returnResult', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
