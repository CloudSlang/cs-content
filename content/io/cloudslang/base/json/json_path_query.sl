#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: This operation takes a reference to JSON (in the form of a string) and runs a specified JSON Path query on it.
#!               It returns the results as a JSON Object.
#!
#! Notes:
#!  1.Query syntax:
#!  JSONPath              Description
#!  ------------          -------------
#!  '$'                   The root object/element
#!  '@'                   The current object/element #!\s+@
#!  '.' or '[]'           Child operator
#!  'n/a'                 Parent operator
#!  '..'                  Recursive descent. JSONPath borrows this syntax from E4X.
#!  '*'                   Wildcard. All objects/elements regardless of their names.
#!  'n/a'                 Attribute access. JSON structures do not have attributes.
#!  '[]'                  Subscript operator. XPath uses it to iterate over element collections and for predicates.
#!                        In Javascript and JSON it is the native array operator.
#!  '[,]'                 Union operator in XPath results in a combination of node sets.
#!                        JSONPath allows alternate names or array indices as a set.
#!  '[start:end:step]'    Array slice operator borrowed from ES4.
#!  '?()'                 Applies a filter (script) expression.
#!  '()'                  Script expression, using the underlying script engine.
#!
#! @input json_object: The JSON in the form of a string.
#!                     Example: {'key1': 'value1', 'key2': 'value2'}
#! @input json_path: The JSON path to be executed.
#!                   Example: '$.key1'
#! @output return_result: The resulted JSON from the query execution.
#! @output return_code: 0 the query succeeded, -1 otherwise.
#! @output exception: The error's stacktrace.
#! @result SUCCESS: The query succeeded
#! @result FAILURE: The query failed.
#!!#
####################################################

namespace: io.cloudslang.base.json
operation: 
   name: json_path_query
   inputs: 
   -  json_object
   -  jsonObject: 
         private: true
         default: ${get('json_object', '')}
         required: false
   -  json_path
   -  jsonPath: 
         private: true
         default: ${get('json_path', '')}
         required: false
   java_action:
      gav: 'io.cloudslang.content:cs-json:0.0.7'
      method_name: execute
      class_name: io.cloudslang.content.json.actions.JsonPathQuery
   outputs: 
   -  return_result: ${returnResult}
   -  return_code: ${returnCode}
   -  exception
   results: 
   -  SUCCESS: ${ returnCode == '0'}
   -  FAILURE
