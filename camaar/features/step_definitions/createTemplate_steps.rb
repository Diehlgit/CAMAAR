Given(/^I am an admin$/) do
  @user = User.create!(
    nome: "administrador",
    email: "adm@unb.br",
    password: 'o_adm_123',
    usuario: "83807519491",
    formacao: "DOUTORADO",
    role: :docente
  )

  @docente = Docente.create!(
    user_id: @user.id,
    departamento: "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
  )
end

Given(/^I am on the templates page$/) do
  visit "/"
  fill_in "user_email", with: @user.email
  fill_in "user_password", with: @user.password
  click_button "Entrar"
end

When(/^I click on the create template button$/) do
  find(".add-button").click
end

When(/^I add the template name$/) do
  fill_in "template_nome", with: "TestedoCapy"
end

When(/^I don't add the template name$/) do
  fill_in "template_nome", with: ""
end

When(/^I add a question title$/) do
  fill_in "template_questaos_attributes_0_pergunta", with: "Questão"
end

When(/^I click on the create button$/) do
  click_link_or_button "Criar Template"
end

Then(/^I should see the template I created$/) do
  expect(page).to have_content "TestedoCapy"
end

Then(/^I should be on the create template page$/) do
  expect(page).to have_content "Criar Novo Template"
end
