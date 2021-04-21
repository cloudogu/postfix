const {
    Given,
    When,
    And,
    Then
} = require("cypress-cucumber-preprocessor/steps");

//
//
// Given
//
//

Given(/^Postfix dogu is not installed$/, function () {
  cy.purgePostfixDogu()
});

//
//
// When
//
//

When(/^etcd key is configured$/, function () {
    cy.setRelayHostInEtcd()
});

And(/^Postfix dogu is installed$/, function () {
    cy.installPostfixDogu()

});

And(/^Postfix dogu is started$/, function () {
    cy.startPostfixDogu()
});

//
//
// Then
//
//

Then(/^Postfix relay host is same as configured in etcd$/, function () {
    cy.readPostfixConfig()
});
