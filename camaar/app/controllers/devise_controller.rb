# frozen_string_literal: true

##
# Controller base para todos os controllers do Devise.
# Este controller fornece funcionalidades comuns para os controllers do Devise,
# como manipulação de recursos, métodos auxiliares e gestão de mensagens de flash.
class DeviseController < Devise.parent_controller.constantize
  include Devise::Controllers::ScopedViews

  # Define o helper DeviseHelper para ser usado nos views.
  if respond_to?(:helper)
    helper DeviseHelper
  end

  # Define métodos helpers para serem usados no controller.
  if respond_to?(:helper_method)
    helpers = %w(resource scope_name resource_name signed_in_resource
                 resource_class resource_params devise_mapping)
    helper_method(*helpers)
  end

  # Configuração inicial do controller.
  prepend_before_action :assert_is_devise_resource!
  self.responder = Devise.responder
  respond_to :html if mimes_for_respond_to.empty?

  # Sobrescreve os prefixos para considerar a view escopada.
  def _prefixes #:nodoc:
    @_prefixes ||= if self.class.scoped_views? && request && devise_mapping
      ["#{devise_mapping.scoped_path}/#{controller_name}"] + super
    else
      super
    end
  end

  # Método interno para marcar métodos internos, excluindo `_prefixes` dos métodos de ação.
  def self.internal_methods #:nodoc:
    super << :_prefixes
  end

  protected

  # Retorna o recurso atual armazenado na variável de instância.
  def resource
    instance_variable_get(:"@#{resource_name}")
  end

  # Proxy para o nome do recurso do Devise.
  def resource_name
    devise_mapping.name
  end
  alias :scope_name :resource_name

  # Proxy para a classe do recurso do Devise.
  def resource_class
    devise_mapping.to
  end

  # Retorna um recurso autenticado da sessão (se existir).
  def signed_in_resource
    warden.authenticate(scope: resource_name)
  end

  # Tenta encontrar a rota mapeada para o Devise com base no caminho da requisição.
  def devise_mapping
    @devise_mapping ||= request.env["devise.mapping"]
  end

  # Verifica se é um recurso mapeado pelo Devise ou não.
  def assert_is_devise_resource! #:nodoc:
    unknown_action! <<-MESSAGE unless devise_mapping
Could not find devise mapping for path #{request.fullpath.inspect}.
This may happen for two reasons:

1) You forgot to wrap your route inside the scope block. For example:

  devise_scope :user do
    get "/some/route" => "some_devise_controller"
  end

2) You are testing a Devise controller bypassing the router.
   If so, you can explicitly tell Devise which mapping to use:

   @request.env["devise.mapping"] = Devise.mappings[:user]

MESSAGE
  end

  # Retorna os formatos de navegação reais suportados pelo Rails.
  def navigational_formats
    @navigational_formats ||= Devise.navigational_formats.select { |format| Mime::EXTENSION_LOOKUP[format.to_s] }
  end

  # Lança uma exceção informando que a ação é desconhecida.
  def unknown_action!(msg)
    logger.debug "[Devise] #{msg}" if logger
    raise AbstractController::ActionNotFound, msg
  end

  # Define o recurso criando uma variável de instância.
  def resource=(new_resource)
    instance_variable_set(:"@#{resource_name}", new_resource)
  end

  # Método helper para uso em before_actions onde não é necessária autenticação.
  def require_no_authentication
    assert_is_devise_resource!
    return unless is_navigational_format?
    no_input = devise_mapping.no_input_strategies

    authenticated = if no_input.present?
      args = no_input.dup.push scope: resource_name
      warden.authenticate?(*args)
    else
      warden.authenticated?(resource_name)
    end

    if authenticated && resource = warden.user(resource_name)
      set_flash_message(:alert, 'already_authenticated', scope: 'devise.failure')
      redirect_to after_sign_in_path_for(resource)
    end
  end

  # Método helper para uso após chamar métodos send_*_instructions em um recurso.
  def successfully_sent?(resource)
    notice = if Devise.paranoid
      resource.errors.clear
      :send_paranoid_instructions
    elsif resource.errors.empty?
      :send_instructions
    end

    if notice
      set_flash_message! :notice, notice
      true
    end
  end

  # Define a mensagem de flash com a chave `key`, usando I18n.
  def set_flash_message(key, kind, options = {})
    message = find_message(kind, options)
    if options[:now]
      flash.now[key] = message if message.present?
    else
      flash[key] = message if message.present?
    end
  end

  # Define a mensagem de flash se `is_flashing_format?` for verdadeiro.
  def set_flash_message!(key, kind, options = {})
    if is_flashing_format?
      set_flash_message(key, kind, options)
    end
  end

  # Define o comprimento mínimo da senha para exibir ao usuário.
  def set_minimum_password_length
    if devise_mapping.validatable?
      @minimum_password_length = resource_class.password_length.min
    end
  end

  def devise_i18n_options(options)
    options
  end

  # Obtém a mensagem para um tipo de chave específico.
  def find_message(kind, options = {})
    options[:scope] ||= translation_scope
    options[:default] = Array(options[:default]).unshift(kind.to_sym)
    options[:resource_name] = resource_name
    options = devise_i18n_options(options)
    I18n.t("#{options[:resource_name]}.#{kind}", **options)
  end

  # Controladores que herdam de DeviseController devem sobrescrever este método
  # para que outros controladores herdem as traduções existentes.
  def translation_scope
    "devise.#{controller_name}"
  end

  # Limpa as senhas do objeto.
  def clean_up_passwords(object)
    object.clean_up_passwords if object.respond_to?(:clean_up_passwords)
  end

  # Responde com formatos de navegação específicos.
  def respond_with_navigational(*args, &block)
    respond_with(*args) do |format|
      format.any(*navigational_formats, &block)
    end
  end

  # Obtém os parâmetros do recurso.
  def resource_params
    params.fetch(resource_name, {})
  end

  ActiveSupport.run_load_hooks(:devise_controller, self)
end
