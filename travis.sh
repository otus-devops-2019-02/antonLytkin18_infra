#!/bin/bash

EXIT_CODE=0
ROOT_DIR=$(pwd)

packer_validate() {
  cd ${ROOT_DIR}
  echo -e "Packer templates validate:\r\n"
  for template in packer/*.json; do
    if [[ ${template} == "packer/variables.json" ]]
    then {
        continue
    }
    fi
    echo -n "Checking template: $template: "
    result="$(packer validate -var-file=packer/variables.json.example ${template})"
    if grep -q "success" <<< ${result}
    then {
        echo -e "Success"
        continue
    }
    fi
    echo -e "Fail: $template"
    echo "$result"
    EXIT_CODE=1
  done
}

ansible_validate() {
  cd ${ROOT_DIR}
  echo -e "\r\nAnsible playbooks validation:\r\n"
  if (ansible-lint ansible/playbooks/*.yml)
  then {
    echo -e "Success"
    return
  }
  fi
  echo -e "Fail"
  EXIT_CODE=1
}

terraform_validate() {
  env=${1}
  cd ${ROOT_DIR}/terraform/${env}
  echo -e "\r\nTerraform validate. Environment ${env}:\r\n"
  vars_example_filename="terraform.tfvars"
  cp terraform.tfvars.example ${vars_example_filename}
  terraform init -backend=false
  result="$(terraform validate)"
  if grep -q "error:" <<< ${result}
  then {
    echo -e "Fail"
    EXIT_CODE=1
    return
  }
  fi
  result="$(tflint)"
  rm -f ${vars_example_filename}
  if grep -q "Awesome!" <<< ${result}
  then {
    echo -e "Success"
    return
  }
  fi
  echo -e "Fail"
  EXIT_CODE=1
}

readme_build_status_validate() {
  cd ${ROOT_DIR}
  echo -e "\r\nReadme validate:\r\n"
  if grep -q "\[Build Status\]" README.md
  then {
    echo -e "Success"
    return
  }
  fi
  echo -e "Fail"
  EXIT_CODE=1
}

mkdir ~/.ssh
touch ~/.ssh/appuser.pub ~/.ssh/appuser

packer_validate
ansible_validate
terraform_validate stage
terraform_validate prod
readme_build_status_validate

exit ${EXIT_CODE}
