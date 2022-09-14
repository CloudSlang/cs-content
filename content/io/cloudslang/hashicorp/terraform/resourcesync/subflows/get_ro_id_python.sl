namespace: io.cloudslang.hashicorp.terraform.resourcesync.subflows
operation:
  name: get_ro_id_python
  inputs:
    - ro_list
  python_action:
    use_jython: false
    script: "import json\ndef execute(ro_list):\n    ro_id = ' '\n    y = json.loads(ro_list)\n    \n    for i in y[\"members\"]:\n        if i[\"displayName\"] == \"Terraform Offering\":\n             ro_id = i[\"@self\"]\n             \n    \n    return {\"ro_id\":ro_id}"
  outputs:
    - ro_id
  results:
    - SUCCESS
