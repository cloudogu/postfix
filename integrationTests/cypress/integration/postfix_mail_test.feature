Feature: Sending a mail via Postfix and receiving it with MailHog

  Scenario: Postfix sends a mail
    Given MailHog mailbox is empty
    When a mail is send via postfix
    Then MailHog receives the mail