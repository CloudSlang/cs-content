namespace: io.cloudslang.hashicorp.terraform.sync.utils
operation:
  name: get_run_id_and_plan_id_python
  inputs:
    - run_list
  python_action:
    use_jython: false
    script: |-
      import json
      def execute(run_list):
          tf_run_id = ' '
          tf_plan_id = ' '
          y = json.loads(run_list)

          for i in y['data']:
              status = i['attributes']['status']
              if status == 'planned' or status == 'applied':
                  tf_run_id = i['id']
                  tf_plan_id = i["relationships"]["plan"]["data"]["id"]
                  break

          return {'tf_run_id': tf_run_id, 'tf_plan_id':tf_plan_id}
  outputs:
    - tf_run_id
    - tf_plan_id
  results:
    - SUCCESS
