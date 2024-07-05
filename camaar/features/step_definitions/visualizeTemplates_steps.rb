Given(/^I'm a logged in user$/) do
  @user = User.create!(
    nome: "administrador",
    email: "adm@unb.br",
    password: 'o_adm_123',
    usuario: "83807519491",
    formacao: "DOUTORADO",
    role: :docente
  )

  Docente.create!(
    user_id: @user.id,
    departamento: "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
  )

  visit "/"
  fill_in "user_email", with: @user.email
  fill_in "user_password", with: @user.password
  click_button "Entrar"
end

Given(/^I click on "Templates"$/) do
  find(".menu-button").click
  find('.select-button#templatesButton').click
end

Given(/^there are no created templates$/) do
end

Given(/^there are any created templates$/) do
  @tipo = Tipo.create!([
                         { nome: 'confirmação', numeroDeAlternativas: 1, discursiva: 'false'},
                         { nome: 'satisfação', numeroDeAlternativas: 5, discursiva: 'false'},
                         { nome: 'múltipla escolha', numeroDeAlternativas: 4, discursiva: 'false'},
                         { nome: 'aberta', numeroDeAlternativas: 0, discursiva: 'true'},
                       ])

  @template = Template.create!(
    nome: 'Template de Exemplo do Cuke+Capy',
    docente: Docente.find_by(user_id: User.find_by(nome: "administrador")),
    questaos_attributes: [
      {
        pergunta: 'você confirma?',
        tipo: Tipo.find_by(nome: 'confirmação'),
        alternativas_attributes: [
          {texto: "confirmo"}
        ]
      },
      {
        pergunta: 'Esta é uma questão de múltipla escolha?',
        tipo: Tipo.find_by(nome: 'múltipla escolha'),
        alternativas_attributes: [
          {texto: "sim"},
          {texto: "si"},
          {texto: "yes"},
          {texto: "oui"}
        ]
      },
      {
        pergunta: 'qual a sua opinião?',
        tipo: Tipo.find_by(nome: 'aberta')
      }
    ]
  )
end

When(/^I click on the "Visualizar" option in the menu$/) do

end

When(/^I click on the "Deletar" option in the menu$/) do
  find('a.trash-button').click
end

When(/^I click on the "Editar" option in the menu$/) do
  find('a.edit-button').click
end

Then(/^I should be headed to the editing screen$/) do
  expect(page).to have_content "Editar Template:"
end
Then(/^I should see no templates on the screen$/) do
  expect(page).to have_no_css(".templates")
end

Then(/^I should not see the template$/) do
  expect(page).to have_no_css(".templates")
end

Then(/^I should be headed to the "Templates" screen$/) do
  expect(page).to have_content "Gerenciamento - Templates"
end

Then(/^I should see all available templates$/) do
  expect(page).to have_content "Template de Exemplo do Cuke+Capy"
end