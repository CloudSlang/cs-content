#   (c) Copyright 2022 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Generate a random password.
#!
#! @input password_length: Password length.
#!                         Default: 1
#!                         Optional
#! @input number_of_lower_case_characters: The minimum number of lower case characters that the password should contain.
#!                                         If 0 it won't contain this type of character.
#!                       Default: 1
#!                       Optional
#! @input number_of_upper_case_characters: The minimum number of upper case characters that the password should contain.
#!                                         If 0 it won't contain this type of character.
#!                       Default: 1
#!                       Optional
#! @input number_of_numerical_characters: The minimum number of numerical characters that the password should contain.
#!                                        If 0 it won't contain this type of character.
#!                       Default: 1
#!                       Optional
#! @input number_of_special_characters: The minimum number of special characters that the password should contain.
#!                                      If 0 it won't contain this type of character. Used special characters are:
#!                                      -=[];,.~!@#$%&*()_+{}|:<>?
#!                       Default: 1
#!                       Optional
#! @input forbidden_characters: A list of characters that the password should not contain. Example: []{}.
#!                       Default: ''
#!                       Optional
#!
#! @output return_result: The generated password or error message in case of failure.
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output exception: In case of success response, this result is empty.
#!                    In case of failure response, this result contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: An error occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: random_password_generator

  inputs:
    - password_length:
        required: false
    - passwordLength:
        default: ${get('password_length', '10')}
        required: false
        private: true
    - number_of_lower_case_characters:
        required: false
    - numberOfLowerCaseCharacters:
        default: ${get('number_of_lower_case_characters', '1')}
        required: false
        private: true
    - number_of_upper_case_characters:
        required: false
    - numberOfUpperCaseCharacters:
        default: ${get('number_of_upper_case_characters', '1')}
        required: false
        private: true
    - number_of_numerical_characters:
        required: false
    - numberOfNumericalCharacters:
        default: ${get('number_of_numerical_characters', '1')}
        required: false
        private: true
    - number_of_special_characters:
        required: false
    - numberOfSpecialCharacters:
        default: ${get('number_of_special_characters', '1')}
        required: false
        private: true
    - forbidden_characters:
        required: false
    - forbiddenCharacters:
        default: ${get('forbidden_characters', '')}
        required: false
        private: true


  java_action:
    gav: 'io.cloudslang.content:cs-utilities:0.1.211'
    class_name: io.cloudslang.content.utilities.actions.RandomPasswordGenerator
    method_name: execute

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${ returnCode == '0'}
    - FAILURE
