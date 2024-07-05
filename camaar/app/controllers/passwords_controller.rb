class PasswordsController < ApplicationController
  before_action :validate_token, only: [:reset_password]

  def create
    user - User.find_by(email: params[:email])
    if @user.present?
      PasswordMailer.with(user: @user).reset.deliver_now
    end
  end

  def edit
    
  end

  def update
    if Current.user.update(password_params)
      redirect_to root_path, notice: "Senha Atualizada!"
    end
  end

  def validate_token
    # Método para validar o token
    user = User.with_reset_password_token(params[:token])
    unless user && user.reset_password_period_valid?
      redirect_to root_path, alert: "Token inválido ou expirado."
    end
  end

  private

  def passwords_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
