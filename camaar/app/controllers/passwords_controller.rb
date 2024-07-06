##
# Controller responsável pelas ações relacionadas à senha dos usuários.
class PasswordsController < ApplicationController

  before_action :validate_token, only: [:reset_password]
  ##
  # POST /passwords
  # Ação para enviar um email de redefinição de senha para o usuário com o email fornecido.
  #
  # Esta ação busca o usuário pelo email fornecido nos parâmetros. Se o usuário for encontrado,
  # um email de redefinição de senha é enviado utilizando o mailer PasswordMailer. Não há retorno
  # visual ao usuário diretamente nesta ação.
  #
  # Parâmetros:
  # - :email - O email do usuário para o qual será enviado o email de redefinição de senha.
  def create
    @user = User.find_by(email: params[:email])
    if @user.present?
      PasswordMailer.with(user: @user).reset.deliver_now
    end
    # Não há retorno visual direto ao usuário nesta ação.
  end

  ##
  # GET /passwords/edit
  # Ação para renderizar o formulário de edição de senha do usuário.
  #
  # Esta ação está atualmente comentada e não está sendo utilizada no código. Ela parece ter
  # a intenção de redirecionar para a página de edição de senha do usuário, utilizando um método
  # de reset de senha. Contudo, isso não está implementado no código atual.
  def edit

    # As linhas comentadas sugerem uma intenção de redirecionar para a página de edição de senha,
    # mas não estão implementadas
  end

  ##
  # PATCH/PUT /passwords
  # Ação para atualizar a senha do usuário atualmente logado.
  #
  # Esta ação atualiza a senha do usuário atualmente logado com base nos parâmetros permitidos.
  # Se a atualização for bem-sucedida, redireciona para a página inicial com uma mensagem de sucesso.
  # Caso contrário, não há tratamento para o erro ou feedback visual ao usuário no código atual.
  #
  # Parâmetros:
  # - :user - Os parâmetros da senha do usuário a serem atualizados (password e password_confirmation).
  def update
    if Current.user.update(password_params)
      redirect_to root_path, notice: "Senha Atualizada!"
    end
    # Falta tratamento para o caso de falha na atualização da senha.
  end

  def validate_token
    # Método para validar o token
    user = User.with_reset_password_token(params[:token])
    unless user && user.reset_password_period_valid?
      redirect_to root_path, alert: "Token inválido ou expirado."
    end
  end

  private

  ##
  # Método privado para filtrar e permitir apenas os parâmetros permitidos para a atualização da senha.
  #
  # Este método é utilizado na ação de atualização de senha para garantir que apenas os parâmetros
  # especificados sejam aceitos.
  #
  # Parâmetros permitidos:
  # - :password - A nova senha do usuário.
  # - :password_confirmation - A confirmação da nova senha do usuário.
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
