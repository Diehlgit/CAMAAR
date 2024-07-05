##
# Mailer responsável pelo envio de e-mails relacionados à redefinição de senha.
class PasswordMailer < ApplicationMailer
  ##
  # Método para enviar e-mail de redefinição de senha.
  #
  # Params:
  # - Nenhum parâmetro explícito é passado diretamente ao método, mas presume-se que ele seja chamado com um hash contendo um usuário (params[:user]).
  #
  # E-mails Enviados:
  # - Envia um e-mail de redefinição de senha para o endereço de e-mail associado ao usuário.
  #
  # Exemplo de Uso:
  #   PasswordMailer.with(user: @user).reset.deliver_now
  def reset
    @token = params[:user].signed_id(purpose: "change_password")

    mail to: params[:user].email
  end
end
