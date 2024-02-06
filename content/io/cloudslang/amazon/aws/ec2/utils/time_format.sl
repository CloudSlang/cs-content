########################################################################################################################
#!!
#! @description: This operation converts the unix time into date format.
#!
#! @input epoch_time: Epoch time.
#! @input time_zone: Scheduler timeZone.
#!
#! @output date_format: Date format.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: Returns the date format.
#! @result FAILURE: An error has occurred while trying to convert unix time to date format.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.utils

operation:
  name: time_format

  inputs:
    - epoch_time
    - epochTime:
        default: ${get('epoch_time', '')}
        required: false
        private: true
    - time_zone
    - timeZone:
        default: ${get('time_zone', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.55-RC1'
    class_name: 'io.cloudslang.content.amazon.actions.utils.GetTimeFormat'
    method_name: 'execute'

  outputs:
    - date_format: ${get('dateFormat', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
