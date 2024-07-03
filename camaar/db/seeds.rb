# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:

Tipo.create!([
  { nome: 'confirmação', numeroDeAlternativas: 1, discursiva: 'false'},
  { nome: 'satisfação', numeroDeAlternativas: 5, discursiva: 'false'},
  { nome: 'múltipla escolha', numeroDeAlternativas: 4, discursiva: 'false'},
  { nome: 'aberta', numeroDeAlternativas: 0, discursiva: 'true'},
])

Disciplina.create!(
  nome: 'Introdução ao Cálculo',
  codigo: 'MAT001'
)

usuarios = [
  {nome: "fulano",
  email: "exemplo@unb.br",
  password: 'senha123',
  usuario: "000001",
  formacao: "graduando",
  role: :dicente},

  {nome: "administrador",
  email: "adm@unb.br",
  password: 'o_adm_123',
  usuario: "83807519491",
  formacao: "DOUTORADO",
  role: :docente}
]

usuarios.each do |user_data|
  user = User.create!(
    nome: user_data[:nome],
    email: user_data[:email],
    password: user_data[:password],
    usuario: user_data[:usuario],
    formacao: user_data[:formacao],
    role: user_data[:role]
  )

  if user.docente?
    Docente.create!(
      user_id: user.id,
      departamento: "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
    )
  elsif user.dicente?
    Dicente.create!(
      user_id: user.id,
      curso: "CIÊNCIAS DA COMPUTAÇÃO",
      matricula: "000001"
    )
  end
end

  Dicente.find_by(user_id: User.find_by(nome: "fulano"))

  turma1 = Turma.create!(
    semestre: '2024.2',
    horario: '24M12',
    class_code: 'TA',
    codigo: 'MAT001',
    disciplina: Disciplina.find_by(nome: "Introdução ao Cálculo"),
    docente: Docente.find_by(user_id: User.find_by(nome: "administrador").id)
  )

  turma2 = Turma.create!(
    semestre: '2024.2',
    horario: '24T34',
    class_code: 'VA',
    codigo: 'CIC097',
    disciplina: Disciplina.find_by(nome: "Introdução ao Cálculo"),
    docente: Docente.find_by(user_id: User.find_by(nome: "administrador").id)
  )

  fulano = Dicente.find_by(user_id: User.find_by(nome: "fulano"))

  fulano.turmas << turma1
  fulano.turmas << turma2
  #turma1.dicentes << fulano

  template1 = Template.create!(
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

  provasDerivadas = Formulario.find_or_create_by(
    nome: 'Pesquisa de Opinião',
    docente_id: Docente.find_by(user_id: User.find_by(nome: "administrador")).id,
    template_id: template1.id,
    dataDeTermino: Date.new(2024, 12, 1),
    respondentes: "aluno, "
  )

  provasDerivadas.turmas << turma1
  #turma1.formularios << provasDerivadas

  def criar_resultados_formulario(formulario)
    template = formulario.template
    template.questaos.each do |questao|
      questao.alternativas.each do |alternativa|
        Resultado.create!(
          formulario: formulario,
          template: template,
          questao: questao,
          alternativa: alternativa,
          respostas: 0,
          respostas_discursivas: "aluno, "
        )
      end
    end
  end

  criar_resultados_formulario(provasDerivadas)

  puts 'Seed percorrida com sucesso'
