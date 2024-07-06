#Eu como Administrador
#Quero visualizar os templates criados
#A fim de poder editar e/ou deletar um template que eu criei

Feature: Visualize created templates

  Background:
    Given I'm a logged in user
    Given I click on "Templates"
    Then I should be headed to the "Templates" screen

  Scenario: No available templates
    Given there are no created templates
    Then I should see no templates on the screen

  Scenario: Templates available
    Given there are any created templates
    Then I should see all available templates


  Scenario: Click on "Deletar"
    Given there are any created templates
    When I click on the "Deletar" option in the menu
    Then I should not see the template

  Scenario: Click on "Editar"
    Given there are any created templates
    When I click on the "Editar" option in the menu
    Then I should be headed to the editing screen

  Scenario: Could not fetch templates from database
    Given I'm on the "Templates" screen
    And an error prevents the templates from being fetched from the database
    Then I should see an error "Houve um error ao tentar acessar os templates na base de dados"