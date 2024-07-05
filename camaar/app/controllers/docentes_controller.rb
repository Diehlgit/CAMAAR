##
# Controller responsável pelas ações relacionadas aos docentes.
class DocentesController < ApplicationController
  before_action :set_docente, only: [:show, :edit, :update, :destroy]

  ##
  # GET /docentes
  # Ação para exibir todos os docentes.
  def index
    @docentes = Docente.all
  end

  def show
  end

  ##
  # GET /docentes/new
  # Ação para exibir o formulário de criação de um novo docente, incluindo também o formulário para criação de um novo usuário.
  def new
    @docente = Docente.new
    @user = User.new
  end

  def edit
  end

  ##
  # POST /docentes
  # Ação para criar um novo docente juntamente com o usuário associado.
  def create
    @user = User.new(user_params)
    @docente = Docente.new(docente_params)
    @docente.user = @user

    if @user.save && @docente.save
      redirect_to @docente, notice: 'Docente foi criado com sucesso.'
    else
      render :new
    end
  end

  ##
  # PATCH/PUT /docentes/1
  # Ação para atualizar os dados de um docente existente.
  def update
    if @docente.update(docente_params)
      redirect_to @docente, notice: 'Docente foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  ##
  # DELETE /docentes/1
  # Ação para excluir um docente existente.
  def destroy
    @docente.destroy
    redirect_to docentes_url, notice: 'Docente foi excluído com sucesso.'
  end

  private
    ##
    # Método para buscar e configurar o docente específico a partir do parâmetro ID.
    def set_docente
      @docente = Docente.find(params[:id])
    end

    ##
    # Método para definir os parâmetros permitidos para a criação ou atualização de um docente.
    def docente_params
      params.require(:docente).permit(:user_id, :departamento)
    end

    ##
    # Método para definir os parâmetros permitidos para a criação de um usuário associado ao docente.
    def user_params
      params.require(:user).permit(:nome, :email, :password, :usuario, :formacao)
    end
end
