#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Describes one or more of the images (AMIs, AKIs, and ARIs) available to you. Images available to you include
#!               public images, private images that you own, and private images owned by other AWS accounts but for which you
#!               have explicit launch permissions.
#!               Note: De-registered images are included in the returned results for an unspecified interval after de-registration.
#! @input provider: Cloud provider on which the instance is - Default: 'amazon'
#! @input endpoint: Endpoint to which first request will be sent - Default: 'https://ec2.amazonaws.com'
#! @input identity: optional - Amazon Access Key ID
#! @input credential: optional - Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: optional - Proxy server used to access the provider services
#! @input proxy_port: optional - Proxy server port used to access the provider services - Default: '8080'
#! @input region: optional - Region where image to be de-registered reside. ListRegionAction can be used in order to get
#!                           all regions. For further details check: http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
#!                         - Default: 'us-east-1'
#! @input identityId: - Scopes the images by users with explicit launch permissions. Specify an AWS account ID, 'self'
#!                      (the sender of the request), or 'all' (public AMIs).
#!                    - Valid: 'self', 'all' or AWS account ID
#!                    - Default: 'self'
#! @input imageIdsString: optional - A string that contains: none, one or more image IDs separated by delimiter.
#!                                 - Default: ''
#! @input ownersString: optional - Filters the images by the owner. Specify an AWS account ID, 'amazon' (owner is Amazon),
#!                                 'aws-marketplace' (owner is AWS Marketplace), 'self' (owner is the sender of the request).
#!                                 Omitting this option returns all images for which you have launch permissions, regardless
#!                                 of ownership.
#!                               - Valid: 'amazon', 'aws-marketplace', or 'self' - Default: 'self'
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output error_message: error message if there was an error when executing, empty otherwise
#! @result SUCCESS: the image was successfully created
#! @result FAILURE: an error occurred when trying to create image
#!!#
####################################################
namespace: io.cloudslang.cloud.amazon_aws.images

operation:
  name: describe_images_in_region

  inputs:
    - provider: 'amazon'
    - endpoint: 'https://ec2.amazonaws.com'
    - identity:
        default: ''
        required: false
        sensitive: true
    - credential:
        default: ''
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        private: true
    - region:
        default: 'us-east-1'
        required: false
    - identity_id:
        required: false
    - identityId: ${get("identity_id", "self")}
    - image_ids_string:
        required: false
    - imageIdsString:
        default: ${get("image_ids_string", "")}
        private: true
    - owners_string:
        required: false
    - ownersString:
        default: ${get("owners_string", "self")}
        private: true

  java_action:
    class_name: io.cloudslang.content.jclouds.actions.images.DescribeImagesInRegionAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${'' if exception not in locals() else exception}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
