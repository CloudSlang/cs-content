cloud-slang-content
=============

CloudSlang is a YAML based language for writing human-readable workflows for the Cloud Slang Orchestration Engine (Score). This repository includes CloudSlang flows and operations.

[![Circle CI](https://circleci.com/gh/CloudSlang/cloud-slang-content/tree/master.svg?style=svg)](https://circleci.com/gh/CloudSlang/cloud-slang-content/tree/master)
[![Build Status](https://travis-ci.org/CloudSlang/cloud-slang-content.svg?branch=master)](https://travis-ci.org/CloudSlang/cloud-slang-content)

#### Getting started:

###### Pre-Requisite: Java JRE >= 7

1. Download the CloudSlang CLI file named cslang-cli-with-content.zip:
    + [Stable release](http://www.cloudslang.io/download)
    + [Latest snapshot](https://github.com/CloudSlang/cloud-slang/releases/latest)
2. Unzip it.
3. Go to the folder /cslang/bin/
4. Run the executable :
  - For Windows : `cslang.bat`
  - For Linux : `bash cslang`
5. Run a simple example print text flow:  `run --f ../content/io/cloudslang/base/print/print_text.sl --i text=first_flow`

**Note:** Some of the content is dependent on external python modules. If you are using the CLI  to run your flows, you can import external modules by doing one of the following:

+ Installing packages into the **python-lib** folder
+ Editing the executable file

**Installing packages into the python-lib folder:**

Prerequisite: **pip** - see **pip**'s [documentation](https://pip.pypa.io/en/latest/installing.html) for how to install. 

1. Edit the **requirements.txt** file in the **python-lib** folder, which is found at the same level as the **bin** folder that contains the CLI executable. 
2. Enter the Python package and all its dependencies in the requirements file.
	+ See the **pip** [documentation](https://pip.pypa.io/en/latest/user_guide.html#requirements-files) for information on how to format the requirements file.
3.  Run the following command from inside the **python-lib** folder:
    ```
    pip install -r requirements.txt -t .
    ```
    **Note:** If your machine is behind a proxy you will need to specify the proxy using pip's `--proxy` flag.

**Note:** If you have defined a `JYTHONPATH` environment variable, you will need to add the **python-lib** folder's path to its value. 

**Editing the executable file**

1. Open the executable found in the **bin** folder for editing.
2. Change the `Dpython.path` key's value to the desired path.

#### Documentation :

All documentation is available on the [CloudSlang website](http://www.cloudslang.io/#/docs).

#### Get Involved

Read our contributing guide [here](CONTRIBUTING.md).

Contact us at [here](mailto:support@cloudslang.io).
