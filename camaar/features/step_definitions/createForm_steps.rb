Given(/^I have classes to assign the form to$/) do
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
  @template = Template.create!(
    nome: 'Template de Exemplo',
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
  
end