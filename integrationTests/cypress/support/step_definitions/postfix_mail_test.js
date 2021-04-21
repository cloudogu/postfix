const {
    Given,
    When,
    Then
} = require("cypress-cucumber-preprocessor/steps");

//
//
// Given
//
//

Given(/^MailHog mailbox is empty$/, function () {
    cy.clearMailHogMailbox()
});

//
//
// When
//
//

When(/^a mail is send via postfix$/, function () {
    cy.postfixSendMail()
});


//
//
// Then
//
//

Then(/^MailHog receives the mail$/, function () {
    let messagesResponse

    cy.mailHogGetMessages().then(function (messagesJson) {
        messagesResponse = messagesJson

        expect(JSON.stringify(messagesResponse).includes("{\"total\":1")).to.be.true
    })
});