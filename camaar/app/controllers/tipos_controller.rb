##
# Controller responsável pelas ações relacionadas aos tipos de um formulário.
class TiposController < ApplicationController

  ##
  # GET /tipos
  # Ação para listar todos os tipos.
  #
  # Esta ação busca todos os registros de tipos na base de dados e os
  # armazena na variável de instância @tipos para serem exibidos na visão correspondente.
  def index
    @tipos = Tipo.all
  end

  ##
  # GET /tipos/:id
  # Ação para exibir um tipo específico.
  #
  # Esta ação busca o tipo com o ID fornecido nos parâmetros e o armazena
  # na variável de instância @tipo para ser exibido na visão correspondente.
  #
  # Parâmetros:
  # - :id - O ID do tipo a ser exibido.
  def show
    @tipo = Tipo.find(params[:id])
  end

  ##
  # GET /tipos/new
  # Ação para inicializar um novo tipo.
  #
  # Esta ação cria uma nova instância de tipo e a armazena na variável de
  # instância @tipo para ser utilizada no formulário de criação de tipo.
  def new
    @tipo = Tipo.new
  end

  ##
  # POST /tipos
  # Ação para criar um novo tipo.
  #
  # Esta ação inicializa uma nova instância de tipo com os parâmetros
  # permitidos, tenta salvá-la na base de dados e, se bem-sucedida,
  # redireciona para a página de exibição do tipo recém-criado; caso
  # contrário, renderiza novamente o formulário de criação com uma mensagem
  # de erro.
  #
  # Parâmetros:
  # - :tipo - Os parâmetros do tipo a ser criado.
  def create
    @tipo = Tipo.new(tipo_params)
    if @tipo.save
      redirect_to @tipo
    else
      flash[:alert] = "Infelizmente houve um erro na criação de seu tipo"
      render 'new'
    end
  end

  ##
  # GET /tipos/:id/edit
  # Ação para editar um tipo existente.
  #
  # Esta ação busca o tipo com o ID fornecido nos parâmetros e o armazena na
  # variável de instância @tipo para ser utilizado no formulário de edição.
  #
  # Parâmetros:
  # - :id - O ID do tipo a ser editado.
  def edit
    @tipo = Tipo.find(params[:id])
  end

  ##
  # PATCH/PUT /tipos/:id
  # Ação para atualizar um tipo existente.
  #
  # Esta ação busca o tipo com o ID fornecido nos parâmetros, tenta atualizar
  # seus atributos com os parâmetros permitidos e salvá-lo na base de dados.
  # Se a atualização for bem-sucedida, redireciona para a página de exibição
  # do tipo; caso contrário, renderiza novamente o formulário de edição.
  #
  # Parâmetros:
  # - :id - O ID do tipo a ser atualizado.
  # - :tipo - Os parâmetros do tipo a serem atualizados.
  def update
    @tipo = Tipo.find(params[:id])
    if @tipo.update(tipo_params)
      redirect_to @tipo
    else
      render 'edit'
    end
  end

  ##
  # DELETE /tipos/:id
  # Ação para deletar um tipo existente.
  #
  # Esta ação busca o tipo com o ID fornecido nos parâmetros, o destrói na
  # base de dados e redireciona para a lista de tipos.
  #
  # Parâmetros:
  # - :id - O ID do tipo a ser deletado.
  def destroy
    @tipo = Tipo.find(params[:id])
    @tipo.destroy
    redirect_to tipos_path
  end

  private

  ##
  # Método privado para filtrar e permitir apenas os parâmetros permitidos
  # para o tipo.
  #
  # Este método é utilizado nas ações de criação e atualização para garantir
  # que apenas os parâmetros especificados sejam aceitos.
  #
  # Parâmetros permitidos:
  # - :nome - Nome do tipo.
  # - :numeroDeAlternativas - Número de alternativas do tipo.
  # - :discursiva - Indicação se o tipo é discursivo.
  def tipo_params
    params.require(:tipo).permit(:nome, :numeroDeAlternativas, :discursiva)
  end
end
