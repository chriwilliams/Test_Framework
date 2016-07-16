# MIST Install & Setup
---

## Purpose
These instructions will help you set up MIST.  It contains guidelines for using and contributing to the MIST project.

## Prerequisites
1. Ruby 2.1.5 installed.
2. The latest version of gem 'bundler' installed.
3. **homebrew** installed (so that you can install git and other dependencies as needed)
4. git installed
5. rvm installed

Clone directly or Fork the MIST repository to your local machine before you start using or contributing to it.
Mac OSX users will have to install and compile the library **free_tds** before going to the next step using [homebrew](http://brew.sh).

     brew install freetds

Open command window and cd to clone MIST location and then type the following command and hit enter.

     bundle install

  The above command will install MediTAF and other dependent gems.

## Home Page
  [https://github.com/mdsol/MIST.git](https://github.com/mdsol/MIST.git)

## Documentation
  [Medinet - MIST](https://sites.google.com/a/mdsol.com/knowledgebase/home/departments/r-d/sqa/utilities/meditaf/mist-meditaf-integration-steps-and-tests)

### Running MIST with Sauce Labs
[MIST - Sauce Labs](https://sites.google.com/a/mdsol.com/knowledgebase/home/departments/r-d/sqa/utilities/meditaf/mist-meditaf-integration-steps-and-tests/using-sauce-labs-with-mist)

## Report Issues
Refer to JIRA Story [MCC-96074](https://medidata.atlassian.net/browse/MCC-96074) and add sub-tasks for issues.
