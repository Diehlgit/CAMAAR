##
# Serviço responsável por lidar com o registro de usuários.
class UserRegistrationService
  ##
  # Método de classe para registrar um usuário e enviar um e-mail de boas-vindas se o usuário for persistido com sucesso.
  #
  # Params:
  # - user (User): O objeto de usuário a ser registrado.
  #
  # Comportamento:
  # - Verifica se o usuário já está persistido no banco de dados (`user.persisted?`).
  # - Se o usuário já estiver persistido, chama o `UserMailer.new_user_email(user).deliver_later` para enviar um e-mail de boas-vindas assincronamente.
  #
  # Exemplo de Uso:
  #   user = User.new(email: 'example@example.com', password: 'password')
  #   UserRegistrationService.call(user)
  #
  #   # Se o usuário for persistido com sucesso, um e-mail de boas-vindas será enviado assincronamente.
  def self.call(user)
    if user.persisted?
      UserMailer.new_user_email(user).deliver_later
    end
  end
end
