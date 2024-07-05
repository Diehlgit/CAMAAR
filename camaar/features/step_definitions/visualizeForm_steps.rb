Given(/^I am a registered user$/) do
  @user = User.create!(
    nome: "fulano",
    email: "exemplo@unb.br",
    password: 'senha123',
    usuario: "000001",
    formacao: "graduando",
    role: :dicente,
  )

  @dicente = Dicente.create!(
    user_id: @user.id,
    curso: "CIÊNCIAS DA COMPUTAÇÃO",
    matricula: "000001"
  )
end

Given(/^I am registered on a class with active forms$/) do

end

Then(/^I should see them on the homepage$/) do
  expect(page).to have_content "Exemplo de Formulário"
end