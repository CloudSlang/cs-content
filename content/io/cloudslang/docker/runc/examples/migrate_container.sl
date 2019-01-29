#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
########################################################################################################################
#!!
#! @description: This flow checks the Docker host's cpu utilization, and migrates a live runc container to another
#!               Docker host without losing real time data..
#!               In order to run this flow you will need to install CRIU from https://criu.org
#!
#!                       How to Prepare your infrastructure for this example
#!
#! @prerequisites:
#!
#! (The following  instructions may changed for future versions of Docker, RUNC or CRIU)
#! 1. Install Docker
#! 2. Install CRIU
#! 3. Run a redis container
#! 4. Save the container to a tar file:
#!    docker export redis > redis.tar
#! 5. Stop and delete the container
#! 6. Create a folder for the redis  runc container.
#! 7. Create a rootfs subfolder, and extract redis.tar to rootfs:
#!     cd redis
#!     tar -C rootfs -xf redis.tar
#! 8. Create a json specification file for the container:
#!     cd redis
#!     docker-runc spec
#! 9. Edit config.json and
#!     a. change terminal to false:
#!     "process": {
#!                    "terminal": false,
#!                    "user": {},
#!                    "args": [
#!                            "redis-server"
#!                    ],
#!    b. change readonly to false
#!     "root": {
#!                    "path": "rootfs",
#!                    "readonly": false
#!            },
#! 10. Create folders for your dump and predump images (mkdir redis/dump;mkdir redis/predump).
#! 11. Start the container: docker-runc start redis
#! 12. On the target host: Install Docker and CRIU, create the folders, copy the redis.tar and config.json files.
#!    and extract redis.tar to the rootfs.
#!    Note: Do not start the container in the target host!
#! 13. In the source host, insert some data to your redis database:
#!     docker-runc exec redis redis-cli set cloudslang super-cool
#!     you are now ready to run the migrate.sl flow
#! 14. When the flow is done, run the following command on the target docker host:
#!     docker-runc exec redis redis-cli get cloudslang
#!
#! A demo if this example is available at https://youtu.be/OrbrMlZiRTY
#!
#! @input pre_dump: perform a pre-dump checkpoint (true/false). pre dumps should be used in normal state in order to
#!                  decrease the migration time of dumps. Thus, in this scenario predump should be false.
#!                  Example: "false"
#! @input docker_host: The address of the Docker host to checkpoint the container on.
#!                     Example: "192.168.0.1"
#! @input destination_host: The address of the Docker host to restore the container on.
#!                          Example: "192.168.0.1"
#! @input port: The ssh port used by the Docker hosts
#! @input username: A user with sufficient privileges on both hosts.
#! @input password: The user's password.
#! @input runc_container: The name of the container to checkpoint.
#!                        Example: "redis"
#! @input target_container: The name of the container to restore (usually identical to the runc_container input).
#! @input root_path: The full path to the folder which contains the containers folders.
#!                   Example: "/usr/local/migrate/"
#! @input predump_image_location: The full path to the folder which will contain the container's pre_dump image.
#! @input dump_image_location: The full path  to the folder which will contain the container's dump image.
#! @input cpu_threshold: The threshold for determining high CPU utilization.
#! @input mail_hostname: The SMTP server address
#! @input mail_port: The SMTP port (usually "25").
#! @input mail_from: The sender's email address
#! @input mail_to: The receiving user/group email address
#!
#! @result SUCCESS: Operation completed successfully
#! @result CHECKPOINT_FAILURE: There was an error while trying to create checkpoint
#! @result TRANSFER_FAILURE: There was an error while trying to transfer
#! @result RESTORE_FAILURE: There was an error while trying to restore
#! @result SEND_MAIL_FAILURE: There was an error while trying to send the mail
#! @result CHECK_THRESHOLD_FAILURE: There was an error while trying to check he threshold
#! @result CHECK_CPU_FAILURE: There was an error while trying to check the CPU
#! @result CONVERT_VALUE_FAILURE: There was an error while trying to convert the value
#! @result EXTRACT_FAILURE: There was an error while trying to extract
#!!#
########################################################################################################################
namespace: io.cloudslang.docker.runc.examples

imports:
  mail: io.cloudslang.base.mail
  comparisons: io.cloudslang.base.comparisons
  runc: io.cloudslang.docker.runc
  linux: io.cloudslang.base.os.linux
  math: io.cloudslang.base.math

flow:
  name: migrate_container

  inputs:
    - docker_host
    - destination_host
    - port: "22"
    - username
    - password
    - runc_container: "redis"
    - target_container: "redis"
    - root_path: "/usr/local/migrate/"
    - pre_dump: "false" # Do not change this value for this scenario. See input description above.
    - predump_image_location: ${root_path + runc_container + "/predump"}
    - dump_image_location: ${root_path + runc_container + "/dump"}
    - cpu_threshold: "60"
    - mail_hostname: "somesmtp"
    - mail_port: "25"
    - mail_from: "senderAddress"
    - mail_to: "ops@myorg"

  workflow:
  - check_cpu:
      do:
        linux.check_linux_cpu_utilization:
          - host: ${docker_host}
          - port
          - username
          - password
          - private_key_file
          - arguments
          - character_set
          - pty
          - timeout
          - close_session
          - agentForwarding
      publish:
          - cpu
      navigate:
          - SUCCESS: convert_value
          - FAILURE: CHECK_CPU_FAILURE

  - convert_value:
      do:
        math.round:
          - value1: ${cpu}
      publish:
          - rounded
      navigate:
          - SUCCESS: check_threshold
          - FAILURE: CONVERT_VALUE_FAILURE

  - check_threshold:
      do:
        comparisons.less_than_percentage:
          - first_percentage: ${rounded}
          - second_percentage: ${cpu_threshold}
      navigate:
          - LESS: SUCCESS
          - MORE: checkpoint_container
          - FAILURE: CHECK_THRESHOLD_FAILURE

  - checkpoint_container:
      do:
        runc.checkpoint_container:
          - docker_host
          - port
          - username
          - password
          - runc_container
          - root_path
          - pre_dump
          - predump_image_location
          - dump_image_location
      navigate:
          - SUCCESS: transfer_container
          - PRE_DUMP_FAILURE: CHECKPOINT_FAILURE
          - DUMP_FAILURE: CHECKPOINT_FAILURE

  - transfer_container:
      do:
        runc.examples.transfer_images:
          - docker_host
          - destination_host
          - port
          - username
          - password
          - runc_container
          - target_container
          - root_path
          - pre_dump
          - predump_image_location
          - dump_image_location
      navigate:
          - SUCCESS: extract_dump
          - PACK_DUMP_FAILURE: TRANSFER_FAILURE
          - TRANSFER_DUMP_FAILURE: TRANSFER_FAILURE
          - DELETE_DUMP_FAILURE: TRANSFER_FAILURE

  - extract_dump:
      do:
        runc.examples.extract_images:
          - docker_host: ${destination_host}
          - port
          - username
          - password
          - runc_container
          - root_path
          - pre_dump
          - predump_image_location
          - dump_image_location
      navigate:
          - SUCCESS: restore_container
          - EXTRACT_PRE_DUMP_FAILURE: EXTRACT_FAILURE

  - restore_container:
      do:
        runc.restore_container:
          - docker_host: ${destination_host}
          - port
          - username
          - password
          - runc_container: ${target_container}
          - root_path
          - pre_dump
          - predump_image_location
          - dump_image_location
      navigate:
          - SUCCESS: send_email
          - RESTORE_DUMP_FAILURE: RESTORE_FAILURE
          - RESTORE_PRE_DUMP_FAILURE: RESTORE_FAILURE

  - send_email:
      do:
        mail.send_mail:
          - hostname: ${mail_hostname}
          - port: ${mail_port}
          - from: ${mail_from}
          - to: ${mail_to}
          - html_email: "true"
          - subject: ${"container " + runc_container + " was migrated"}
          - body: >
              ${'container ' + runc_container + ' was migrated to <BR>Host -  ' +
              destination_host + '<BR>Container -  ' + target_container +
              '<BR>In order to see an entered value run the followig command on the target host:' +
              '<BR>docker-runc exec redis redis-cli get cloudslang<BR>Thank You...'}
      navigate:
          - SUCCESS: SUCCESS
          - FAILURE: SEND_MAIL_FAILURE

  results:
    - SUCCESS
    - CHECKPOINT_FAILURE
    - TRANSFER_FAILURE
    - RESTORE_FAILURE
    - SEND_MAIL_FAILURE
    - CHECK_THRESHOLD_FAILURE
    - CHECK_CPU_FAILURE
    - CONVERT_VALUE_FAILURE
    - EXTRACT_FAILURE
