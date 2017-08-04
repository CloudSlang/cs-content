########################################################################################################################
#!!
#! @description: Workflow that tests quote_check.
#!               It uses property files to obtain the file paths and the default values.
#!
#! @input file_path: Path for the file containing the quotes.
#! @input default_quote: Default quote to be displayed.
#!
#! @result SUCCESS_PRINTING_DEFAULT: Quote printed successfully.
#! @result QUOTE_EXISTS: The random quote was generated successfully.
#! @result FILE_DOES_NOT_OPEN: The file can't be open.
#! @result CANT_CHECK_QUOTE: Quote_check step failed.
#! @result FAILURE: An error occurred.
#!!#
########################################################################################################################

namespace: test.io.cloudslang.base.examples

imports:
  base: io.cloudslang.base.print
  utils: io.cloudslang.base.utils
  fs: io.cloudslang.base.filesystem
  strings: io.cloudslang.base.strings
  quote_generator: io.cloudslang.base.examples.yoda

flow:
  name: test_quote_check

  inputs:
    - default_quote:
        default: 'Do or do not, there is no try!'
        private: true
    - file_path:
        default: ${get_sp('io.cloudslang.base.examples.yoda.file_path')}
        required: false

  workflow:
    - check_system_property:
        do:
          utils.is_true:
          - bool_value: ${get_sp('io.cloudslang.base.examples.yoda.default_quote', 'false')}
        navigate:
          - 'TRUE': SUCCESS_PRINTING_DEFAULT
          - 'FALSE': check_random_quote

    - check_random_quote:
        do:
          quote_generator.quote_check:
            - file_path
        publish:
          - random_quote
        navigate:
          - SUCCESS: check_quote
          - FAILURE: CANT_CHECK_QUOTE

    - check_quote:
        do:
          fs.read_from_file:
            - file_path
        publish:
          - read_text
        navigate:
          - SUCCESS: check_quote_exists
          - FAILURE: FILE_DOES_NOT_OPEN

    - check_quote_exists:
        do:
          strings.string_occurrence_counter:
              - string_in_which_to_search: ${read_text}
              - string_to_find: ${random_quote}
        navigate:
          - SUCCESS: QUOTE_EXISTS
          - FAILURE: FAILURE

  results:
    - SUCCESS_PRINTING_DEFAULT
    - QUOTE_EXISTS
    - FILE_DOES_NOT_OPEN
    - CANT_CHECK_QUOTE
    - FAILURE
