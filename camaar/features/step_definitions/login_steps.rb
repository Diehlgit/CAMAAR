Given(/^I'm on the Login page$/) do
  visit "/"
end

Given(/^I'm a registered user$/) do
  @user = User.create!(
    nome: "administrador",
    email: "adm@unb.br",
    password: 'o_adm_123',
    usuario: "83807519491",
    formacao: "DOUTORADO",
    role: :docente
  )
end

When(/^I click on the submit button$/) do
  click_button "Entrar"
end

When(/^I fill the email textfield with my email$/) do
  fill_in "user_email", with: @user.email
end

When(/^I fill the password textfield with my password$/) do
  fill_in "user_password", with: @user.password
end

Then(/^I should be on the Home page$/) do
  expect(page).to have_content "Gerenciamento - Templates"
end

Then(/^I should be prompted with "([^"]*)"$/) do |message|
  expect(page).to have_content message
end

When(/^I fill the password textfield with the wrong password$/) do
  fill_in "user_password", with: "."
end

When(/^I fill the email textfield with the wrong email$/) do
  fill_in "user_email", with: "."
end