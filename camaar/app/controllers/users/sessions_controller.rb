class Users::SessionsController < Devise::SessionsController
  ##
  # Renderiza a página de login.
  #
  # Comportamento:
  # - Cria uma nova instância do recurso (usuário) utilizando os parâmetros de login fornecidos.
  # - Limpa os dados de senha do recurso para segurança.
  # - Renderiza o template 'devise/sessions/new' para exibir o formulário de login.
  #
  # Exemplo de Uso:
  #   # Rota: GET /users/sign_in
  #   Users::SessionsController.new
  #
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    render 'devise/sessions/new'
  end

  ##
  # Cria uma sessão de usuário após a autenticação.
  #
  # Comportamento:
  # - Autentica o usuário utilizando as opções de autenticação fornecidas pelo Warden.
  # - Define uma mensagem de flash indicando que o usuário foi autenticado com sucesso, se o formato de navegação for navegacional.
  # - Registra o usuário como autenticado.
  # - Redireciona o usuário de volta para a página de origem (se existir) ou para a página definida após o login.
  #
  # Exemplo de Uso:
  #   # Rota: POST /users/sign_in
  #   Users::SessionsController.create
  #
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if !session[:return_to].blank?
      redirect_to session[:return_to]
      session[:return_to] = nil
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  protected

  ##
  # Define o caminho para onde redirecionar após o login.
  #
  # Comportamento:
  # - Verifica se o recurso autenticado é um dicente ou docente e redireciona para a página inicial correspondente.
  # - Caso contrário, utiliza o método padrão de Devise para o redirecionamento.
  #
  # Exemplo de Uso:
  #   # Após o login bem-sucedido, redireciona para a página inicial do usuário.
  #   Users::SessionsController.after_sign_in_path_for(resource)
  #
  def after_sign_in_path_for(resource)
    if resource.dicente?
      home_dicente_path
    elsif resource.docente?
      home_docente_path
    else
      super
    end
  end

  ##
  # Define o caminho para onde redirecionar após o logout.
  #
  # Comportamento:
  # - Sempre redireciona para a página inicial da aplicação após o logout.
  #
  # Exemplo de Uso:
  #   # Após o logout, redireciona para a página inicial.
  #   Users::SessionsController.after_sign_out_path_for(resource_or_scope)
  #
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
