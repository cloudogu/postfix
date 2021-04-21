Feature: Configuring Postfix via etcd

  Scenario: Postfix relay host is read from etcd
    Given Postfix dogu is not installed
    When etcd key is configured
    And Postfix dogu is installed
    And Postfix dogu is started
    Then Postfix relay host is same as configured in etcd