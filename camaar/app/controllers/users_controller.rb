##
# Controller responsável pelas ações relacionadas ao usuário.
class UsersController < ApplicationController
  # Garante que o usuário esteja autenticado antes de permitir acesso às ações.
  before_action :authenticate_user!

  ##
  # GET /users
  # Ação para listar todos os usuários.
  #
  # Esta ação busca todos os registros de usuários na base de dados e os
  # armazena na variável de instância @users para serem exibidos na visão correspondente.
  def index
    @users = User.all
  end

  ##
  # GET /users/:id
  # Ação para exibir um usuário específico.
  #
  # Esta ação busca o usuário com o ID fornecido nos parâmetros e o armazena
  # na variável de instância @user para ser exibido na visão correspondente.
  #
  # Parâmetros:
  # - :id - O ID do usuário a ser exibido.
  def show
    @user = User.find(params[:id])
  end

  ##
  # GET /users/new
  # Ação para inicializar um novo usuário.
  #
  # Esta ação cria uma nova instância de usuário e a armazena na variável de
  # instância @user para ser utilizada no formulário de criação de usuário.
  def new
    @user = User.new
  end

  ##
  # POST /users
  # Ação para criar um novo usuário.
  #
  # Esta ação determina o tipo de usuário a ser criado (Docente, Dicente ou
  # User padrão) com base nos parâmetros fornecidos. Cria uma instância do
  # tipo correspondente, preenche com os parâmetros permitidos e tenta salvar
  # na base de dados. Se o salvamento for bem-sucedido, redireciona para a
  # página de exibição do usuário recém-criado com uma mensagem de sucesso;
  # caso contrário, renderiza novamente o formulário de criação.
  #
  # Parâmetros:
  # - :user - Os parâmetros do usuário a ser criado.
  def create
    # Determine qual tipo de usuário está sendo criado com base nos parâmetros.
    if user_params[:type] == 'Docente'
      @user = Docente.new(user_params.except(:type, :matricula, :curso))
    elsif user_params[:type] == 'Dicente'
      @user = Dicente.new(user_params.except(:type, :departamento))
    else
      @user = User.new(user_params)
    end

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  ##
  # GET /users/:id/edit
  # Ação para editar um usuário existente.
  #
  # Esta ação busca o usuário com o ID fornecido nos parâmetros e o armazena
  # na variável de instância @user para ser utilizado no formulário de edição.
  #
  # Parâmetros:
  # - :id - O ID do usuário a ser editado.
  def edit
    @user = User.find(params[:id])
  end

  ##
  # PATCH/PUT /users/:id
  # Ação para atualizar um usuário existente.
  #
  # Esta ação busca o usuário com o ID fornecido nos parâmetros, tenta
  # atualizar seus atributos com os parâmetros permitidos e salva na base de
  # dados. Se a atualização for bem-sucedida, redireciona para a página de
  # exibição do usuário com uma mensagem de sucesso; caso contrário, renderiza
  # novamente o formulário de edição.
  #
  # Parâmetros:
  # - :id - O ID do usuário a ser atualizado.
  # - :user - Os parâmetros do usuário a serem atualizados.
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  ##
  # DELETE /users/:id
  # Ação para deletar um usuário existente.
  #
  # Esta ação busca o usuário com o ID fornecido nos parâmetros, o destrói na
  # base de dados e redireciona para a lista de usuários com uma mensagem de
  # sucesso.
  #
  # Parâmetros:
  # - :id - O ID do usuário a ser deletado.
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  ##
  # Método privado para filtrar e permitir apenas os parâmetros permitidos
  # para o usuário.
  #
  # Este método é utilizado nas ações de criação e atualização para garantir
  # que apenas os parâmetros especificados sejam aceitos.
  #
  # Parâmetros permitidos:
  # - :nome - Nome do usuário.
  # - :email - Email do usuário.
  # - :password - Senha do usuário.
  # - :usuario - Nome de usuário.
  # - :formacao - Formação do usuário.
  def user_params
    params.require(:user).permit(:nome, :email, :password, :usuario, :formacao)
  end
end
