// The MailHog API is used here in version 1 and in version 2.
// Reasons:
// -in version 2 the method to delete the mails in the mailbox is missing.
// -in version 2 the response to the query of the mails in the mailbox is easier and better to evaluate for the tests
const mailHogApiV1Path = "/api/v1"
const mailHogApiV2Path = "/api/v2"

/**
 * Deletes all messages from the MailHog mailbox.
 */
const clearMailHogMailbox = () => {
    cy.request({
        method: "DELETE",
        url: Cypress.config().mailHogBaseUrl + mailHogApiV1Path + "/messages"
    }).then((response) => {
        expect(response.status).to.eq(200)
        return response.body
    })
}

/**
 * Sends mail in the postfix dogu in the Vagrant machine.
 */
const postfixSendMail = () => {
    cy.exec("vagrant ssh -c \"sudo docker exec postfix sendmail -t postfix-it@cloudogu.com\"")
}

/**
 * Query the messages from the MailHog mailbox and return the request response.
 */
const mailHogGetMessages = () => {
    cy.request({
        method: "GET",
        url: Cypress.config().mailHogBaseUrl + mailHogApiV2Path + "/messages"
    }).then((response) => {
        expect(response.status).to.eq(200)
        return response.body
    })
}

Cypress.Commands.add("clearMailHogMailbox", clearMailHogMailbox)
Cypress.Commands.add("postfixSendMail", postfixSendMail)
Cypress.Commands.add("mailHogGetMessages", mailHogGetMessages)