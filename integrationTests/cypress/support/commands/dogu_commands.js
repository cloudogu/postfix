const relayHost = "192.168.56.1:1025"
const vagrantMachineID = Cypress.config().vagrantMachineID


/**
 * Purges the Postfix dogu in the vagrant machine.
 */
const purgePostfixDogu = () => {
    cy.exec("vagrant ssh -c \"sudo cesapp purge postfix\" " + vagrantMachineID, {failOnNonZeroExit: false})
}

/**
 * Set etcd entry for postfix relay host. This entry is removed during a purge.
 */
const setRelayHostInEtcd = () => {
    cy.exec("vagrant ssh -c \"etcdctl set /config/postfix/relayhost " + relayHost + "\" " + vagrantMachineID)
}

/**
 * Installs the postfix dogu in the vagrant machine.
 */
const installPostfixDogu = () => {
    cy.exec("vagrant ssh -c \"sudo cesapp install official/postfix\" " + vagrantMachineID)
}

/**
 * Starts the postfix dogu in the vagrant machine
 */
const startPostfixDogu = () => {
    cy.exec("vagrant ssh -c \"sudo cesapp start postfix\" " + vagrantMachineID)
}

/**
 * Checks if the expected relay host is set in the postfix configuration.
 */
const checkConfiguredRelayHost = () => {
    cy.exec("vagrant ssh -c \"sudo docker exec postfix cat /etc/postfix/main.cf\" " + vagrantMachineID)
        .its('stdout')
        .should('contain', "relayhost = " + relayHost)
}

Cypress.Commands.add("purgePostfixDogu", purgePostfixDogu)
Cypress.Commands.add("setRelayHostInEtcd", setRelayHostInEtcd)
Cypress.Commands.add("installPostfixDogu", installPostfixDogu)
Cypress.Commands.add("startPostfixDogu", startPostfixDogu)
Cypress.Commands.add("readPostfixConfig", checkConfiguredRelayHost)
