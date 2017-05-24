Feature: AppManagement

  Background:
    Given apps are in two directories "apps" and "apps2"

  Scenario: Two app instances exist the first is more recent
    Given App "testapp" with version "1.0.1" exists in dir "apps"
    And App "testapp" with version "1.0.0" exists in dir "apps2"
    When App "testapp" is loaded
    Then "testapp" version should be "1.0.1"

  Scenario: Two app instances exist the second is more recent
    Given App "testapp" with version "1.0.0" exists in dir "apps"
    And App "testapp" with version "1.0.1" exists in dir "apps2"
    When App "testapp" is loaded
    Then "testapp" version should be "1.0.1"
    
