##
# Controller responsável pelas ações relacionadas aos discentes.
class DicentesController < ApplicationController
  before_action :set_dicente, only: [:show, :edit, :update, :destroy]

  ##
  # GET /dicentes
  # Ação para listar todos os discentes cadastrados.
  def index
    @dicentes = Dicente.all
  end

  ##
  # GET /dicentes/:id
  # Ação para exibir os detalhes de um discente específico.
  def show
  end

  ##
  # GET /dicentes/new
  # Ação para exibir o formulário de criação de um novo discente.
  def new
    @dicente = Dicente.new
    @user = User.new
  end

  ##
  # POST /dicentes
  # Ação para criar um novo discente com base nos parâmetros recebidos do formulário de criação.
  def create
    @user = User.new(user_params)
    @dicente = Dicente.new(dicente_params)

    if @dicente.save
      redirect_to @dicente, notice: 'Dicente foi criado com sucesso.'
    else
      render :new
    end
  end

  ##
  # GET /dicentes/:id/edit
  # Ação para exibir o formulário de edição dos dados de um discente existente.
  def edit
  end

  ##
  # PATCH/PUT /dicentes/:id
  # Ação para atualizar os dados de um discente existente com base nos parâmetros recebidos do formulário de edição.
  def update
    if @dicente.update(dicente_params)
      redirect_to @dicente, notice: 'Dicente foi atualizado com sucesso.'
    else
      render :edit
    end
  end

  ##
  # DELETE /dicentes/:id
  # Ação para excluir um discente existente.
  def destroy
    @dicente.destroy
    redirect_to dicientes_url, notice: 'Dicente foi excluído com sucesso.'
  end

  private
    ##
    # Método para buscar e configurar o discente específico a partir do parâmetro ID.
    def set_dicente
      @dicente = Dicente.find(params[:id])
    end

    ##
    # Método para definir os parâmetros permitidos para a criação ou atualização de um discente.
    def dicente_params
      params.require(:dicente).permit(:user_id, :matricula, :curso)
    end

    ##
    # Método para definir os parâmetros permitidos para a criação ou atualização de um usuário associado ao discente.
    def user_params
      params.require(:user).permit(:nome, :email, :password, :usuario, :formacao)
    end
end
