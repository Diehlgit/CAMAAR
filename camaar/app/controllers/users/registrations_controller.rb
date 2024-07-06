class Users::RegistrationsController < Devise::RegistrationsController
  ##
  # Configuração dos parâmetros permitidos para registro de usuário.
  #
  # Comportamento:
  # - Define quais parâmetros são permitidos durante o processo de registro de usuário.
  #
  # Exemplo de Uso:
  #   # Permite os parâmetros 'nome' e 'role' durante o registro de usuário.
  #   Users::RegistrationsController.configure_permitted_parameters
  #
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nome, :role])
  end

  ##
  # Criação de um novo registro de usuário.
  #
  # Comportamento:
  # - Chama o método de criação padrão de Devise para registro de usuário.
  # - Após a criação bem-sucedida do usuário, executa o serviço de notificação de novo usuário.
  #
  # Exemplo de Uso:
  #   # Rota: POST /users
  #   Users::RegistrationsController.create
  #
  def create
    super do |resource|
      UserRegistrationService.call(resource)
    end
  end
end
