Given(/^I have classes to assign the form to$/) do
  @disciplina = Disciplina.create!(
    nome: 'Introdução ao Cálculo',
    codigo: 'MAT001'
  )

  @turma = Turma.create!(
    semestre: '2024.2',
    horario: '24M12',
    class_code: 'TA',
    codigo: 'MAT001',
    disciplina: Disciplina.find_by(nome: "Introdução ao Cálculo"),
    docente: Docente.find_by(user_id: User.find_by(nome: "administrador").id)
  )
end

Given(/^I have available templates to choose from$/) do
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

When(/^I choose a template$/) do
  visit "/"
  fill_in "user_email", with: @user.email
  fill_in "user_password", with: @user.password
  click_button "Entrar"

  expect(page).to have_content "Formularios"

  click_link_or_button "Formularios"
  find(".add-button").click

  click_link_or_button "formulario_turma_ids"
end

When(/^I click on the "Criar" button$/) do
  click_link_or_button "Criar"
end

Then(/^I should be able to create a form$/) do
  expect(page).to have_content "Template de Exemplo do Cuke+Capy"
end