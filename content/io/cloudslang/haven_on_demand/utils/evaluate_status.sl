#   (c) Copyright 2016 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Evaluates status
#!
#! @input status: status to evaluate
#! @result FINISHED
#! @result IN_PROGRESS
#! @result QUEUED
#! @result FAILURE
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.utils

decision:
  name: evaluate_status

  inputs:
    - status

  results:
    - FINISHED: ${status == 'finished'}
    - IN_PROGRESS: ${status == 'in progress'}
    - QUEUED: ${status == 'queued'}
    - FAILURE
