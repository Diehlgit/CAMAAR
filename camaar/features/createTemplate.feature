#Eu como Administrador
#Quero criar um template de formulário contendo as questões do formulário
#A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

Feature: create template

  Scenario: can access template creation
    Given I am an admin
    And I am on the templates page
    When I click on the create template button
    Then I should be on the create template page

  Scenario: create a template
    Given I am an admin
    And I am on the templates page
    When I click on the create template button
    And I add the template name
    And I add a question title
    When I click on the create button
    Then I should see the template I created

  Scenario: no template name
    Given I am an admin
    And I am on the templates page
    When I click on the create template button
    And I don't add the template name
    And I add a question title
    When I click on the create button
    Then I should be prompted with "Dê um nome ao seu Template."

#Esse cenário está considerando que é possível criar um template vazio, caso seja do interesse do admin
  Scenario: empty template questions
    Given I am an admin
    And I am on the templates page
    When I click on the create template button
    And I add the template name
    And  I click on the create button
    Then I should see the template I created