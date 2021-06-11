<a href="http://cloudslang.io/">
    <img src="https://camo.githubusercontent.com/ece898cfb3a9cc55353e7ab5d9014cc314af0234/687474703a2f2f692e696d6775722e636f6d2f696849353630562e706e67" alt="CloudSlang logo" title="CloudSlang" align="right" height="60"/>
</a>

CloudSlang Content
==================

[![Join the chat at https://gitter.im/CloudSlang/cs-content](https://badges.gitter.im/CloudSlang/cs-content.svg)](https://gitter.im/CloudSlang/cs-content?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

CloudSlang is a [YAML](http://yaml.org) based language for writing human-readable workflows for the Cloud Slang Orchestration Engine (Score). This repository includes CloudSlang flows and operations.

[![Build Status](https://travis-ci.com/CloudSlang/cs-content.svg?branch=master)](https://travis-ci.com/CloudSlang/cs-content)

Click [here](/DOCS.md) for an overview of all the currently supported integrations.

#### Getting started:

###### Pre-Requisite: Java JRE >= 7

1. Download the CloudSlang CLI file named cslang-cli-with-content:
    + [Stable release](https://github.com/CloudSlang/cloud-slang/releases/latest)
    + [Latest snapshot](https://github.com/CloudSlang/cloud-slang/releases/)
2. Extract it.
3. Go to the folder `cslang/bin/`
4. Run the executable :
  - For Windows : `cslang.bat`
  - For Linux : `bash cslang`
5. Run a simple example print text flow: `run --f ../content/io/cloudslang/base/print/print_text.sl --i text=first_flow --cp ../content/`

Command line arguments in the above example:

Argument|Description
---|---
--f | Location of the flow to run.
--i | Arguments the flow takes as input, for multiple arguments use a comma delimited list (e.g. `var1=value1,var2=value2`).
--cp | Classpath for the location of the content. Required when content imports other content.


**Note:** Some of the content is dependent on external python modules. If you are using the CLI to run your flows, you can import external modules by doing one of the following:

+ Installing packages into the **python-lib** folder
+ Editing the executable file

**Installing packages into the python-lib folder:**

Prerequisites:  Python 2.7 and pip.

You can download Python (version 2.7) from [here](https://www.python.org/). Python 2.7.9 and later include pip by default. If you already have Python but don't have pip, see the pip [documentation](https://pip.pypa.io/en/latest/installing.html) for
installation instructions.

1. Edit the **requirements.txt** file in the **python-lib** folder, which is found at the same level as the **bin** folder that contains the CLI executable.
2. Enter the Python package and all its dependencies in the requirements file.
	+ See the **pip** [documentation](https://pip.pypa.io/en/latest/user_guide.html#requirements-files) for information on how to format the requirements file.
3.  Run the following command from inside the **python-lib** folder:
    ```bash
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

Contact us [here](mailto:support@cloudslang.io).
