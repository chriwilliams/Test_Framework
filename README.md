<<<<<<< HEAD
# MIST
MediTAF Integration Steps and Tests (MIST) is a shared repository to store automated tests and related files which use MediTAF framework. MIST will allow teams working on different projects to share feature files and automation libraries. This will increase knowledge-sharing, prevent duplication of work, and decrease maintenance.

Prerequisites for using MediTAF and MIST:

1. Ruby 2.1.5 installed.
2. The latest version of gem 'bundler' installed.

To develop automated tests using the MediTAF framework and MIST, the following steps must be completed below:

## Setup MIST and Install MediTAF

Clone directly or Fork the MIST repository to your local machine before you start using or contributing to it.

Open command window and cd to clone MIST location and then type the following command and hit enter.

     bundle install

  The above command will install MediTAF and other dependent gems.

## Home Page
  [https://github.com/mdsol/MIST.git](https://github.com/mdsol/MIST.git)

## Documentation
  [Medinet - MIST](https://sites.google.com/a/mdsol.com/knowledgebase/home/departments/r-d/sqa/utilities/meditaf/mist-meditaf-integration-steps-and-tests)

### Running MIST with Sauce Labs
[MIST - Sauce Labs](https://sites.google.com/a/mdsol.com/knowledgebase/home/departments/r-d/sqa/utilities/meditaf/mist-meditaf-integration-steps-and-tests/using-sauce-labs-with-mist)
=======
# Test Framework

Test frameworks are one of the key requirements for implementing a successful automated software testing solution. A good test framework reduces maintenance costs, and speeds up test development. Currently at Medidata, we have several test frameworks that are successfully used in various projects. However, they have been designed with a focus on a product or a project, rendering them unusable in cross-product or multi-interface automation projects.

MediTAF is a generic ruby-based test automation framework intended to allow automation engineers and testers to design end-to-end automated integration tests for distributed systems. Specifically, MediTAF will allow testers to automate using two different interfaces i.e. UI and web services.


## Key Features

  * **UI testing:** MediTAF uses Selenium to allow users to write tests for the web user interface. For Selenium implementation, the framework uses the Page Object pattern. The Page Object pattern represents screens of a web application in a series of objects and encapsulates the features represented by a web page. It reduces the duplication of code and improves the maintainability of the automated tests. MediTAF uses a ruby gem called **site_prism** (an extension to **Capybara**) as an interface to **selenium-webdriver** to implement the Page Object pattern.
  * **Services testing:** MediTAF provides an interface to connect with the services. Testers will be able to make calls to the service APIs, save results and perform comparisons with the expected results. Framework provides wrapper classes so nothing changes in the implementation. The framework also allows for future expansion to other services without affecting existing implementations.
  * **Logging and Exception Handling:** The framework has an exception handler with multiple severity levels that can be logged to a configured file.


## Advantages of using Test Framework

 * Enables testers to automate tests across multiple Medidata interfaces and applications.
 * The framework interprets the **Cucumber/Gherkin** language for the creation and execution of requirement/feature files.
 * Allows for central location repository of features and step definitions - [MIST](https://github.com/mdsol/MIST.git) ( MediTAF Integration Steps and Tests )
 * Enhances collaboration among testers, developers, and product managers to facilitate and simplify cross-team and cross-platform testing efforts.
 * Reduces maintenance by minimizing duplication of code.
 * Provides a way for standardized logging and validation output across multiple products.
 * Allows easy execution of end-to-end automated tests.


## Home Page
  [https://github.com/mdsol/MediTAF.git](https://github.com/mdsol/MediTAF.git)

## Documentation
  [Medinet - MediTAF](https://sites.google.com/a/mdsol.com/knowledgebase/home/departments/r-d/sqa/utilities/MediTAF)
>>>>>>> 53b8c1ad140d5f6e775fce1096d63c0a411f7ddc

## Report Issues
Refer to JIRA Story [MCC-96074](https://medidata.atlassian.net/browse/MCC-96074) and add sub-tasks for issues.

<<<<<<< HEAD
## Copyright

Copyright © 2013-2015 Medidata Solutions, Inc. All Rights Reserved.
=======
## Installation Instructions


## Copyright

>>>>>>> 53b8c1ad140d5f6e775fce1096d63c0a411f7ddc
