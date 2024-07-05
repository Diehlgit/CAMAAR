##
# Controller responsável pelas ações relacionadas aos templates.
class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  ##
  # Procura um template pelo nome.
  #
  # Esta ação busca um template na base de dados pelo nome fornecido nos parâmetros.
  # Se encontrado, redireciona para a página de edição do template; caso contrário,
  # redireciona para a página inicial do docente com uma mensagem de aviso.
  #
  # Parâmetros:
  # - :nome - O nome do template a ser procurado.
  def search
    @template = Template.find_by(nome: params[:nome])
    if @template
      redirect_to edit_template_path(@template)
    else
      redirect_to home_docente_url, notice: 'Template não encontrado'
    end
  end

  ##
  # GET /templates
  # Ação para listar todos os templates.
  #
  # Esta ação busca todos os registros de templates na base de dados e os
  # armazena na variável de instância @templates para serem exibidos na visão correspondente.
  def index
    @templates = Template.all
  end

  def show
  end

  ##
  # GET /templates/new
  # Ação para inicializar um novo template.
  #
  # Esta ação cria uma nova instância de template e inicializa uma questão
  # e uma alternativa associadas, armazenando-as na variável de instância
  # @template para serem utilizadas no formulário de criação de template.
  def new
    @template = Template.new
    questao = @template.questaos.build
    questao.alternativas.build
  end

  def edit
  end

  ##
  # POST /templates
  # Ação para criar um novo template.
  #
  # Esta ação inicializa uma nova instância de template com os parâmetros
  # permitidos, associa o template ao docente correspondente ao usuário
  # atual, tenta salvá-lo na base de dados e, se bem-sucedida, redireciona
  # para a página inicial do docente com uma mensagem de sucesso; caso
  # contrário, renderiza novamente o formulário de criação com os erros.
  #
  # Parâmetros:
  # - :template - Os parâmetros do template a ser criado.
  def create
    @template = Template.new(template_params)
    @template.docente = Docente.find_by(user_id: current_user.id)

    if @template.save
      redirect_to home_docente_url, notice: 'Template foi criado com sucesso.'
    else
      render :new
    end
  end

  ##
  # PATCH/PUT /templates/:id
  # Ação para atualizar um template existente.
  #
  # Esta ação busca o template com o ID fornecido nos parâmetros, tenta
  # atualizar seus atributos com os parâmetros permitidos e salvá-lo na
  # base de dados. Se a atualização for bem-sucedida, redireciona para a
  # página inicial do docente com uma mensagem de sucesso; caso contrário,
  # renderiza novamente o formulário de edição com os erros.
  #
  # Parâmetros:
  # - :id - O ID do template a ser atualizado.
  # - :template - Os parâmetros do template a serem atualizados.
  def update
    if @template.update(template_params)
      redirect_to home_docente_url, notice: 'Questão atualizada com sucesso.'
    else
      render :edit
    end
  end

  ##
  # DELETE /templates/:id
  # Ação para deletar um template existente.
  #
  # Esta ação busca o template com o ID fornecido nos parâmetros e tenta
  # destruí-lo na base de dados. Se a exclusão for bem-sucedida, redireciona
  # para a página inicial do docente com uma mensagem de sucesso; caso contrário,
  # redireciona para a mesma página com uma mensagem de erro.
  #
  # Parâmetros:
  # - :id - O ID do template a ser deletado.
  def destroy
    if @template.destroy
      redirect_to home_docente_url, notice: 'Template excluído com sucesso.'
    else
      redirect_to home_docente_url, alert: 'Erro ao excluir o template.'
    end
  end

  private

  ##
  # Método privado para buscar um template específico pelo ID.
  #
  # Este método é utilizado nas ações show, edit, update e destroy para
  # buscar o template com o ID fornecido nos parâmetros e armazená-lo na
  # variável de instância @template.
  #
  # Parâmetros:
  # - :id - O ID do template a ser buscado.
  def set_template
    @template = Template.find(params[:id])
  end

  ##
  # Método privado para filtrar e permitir apenas os parâmetros permitidos
  # para o template.
  #
  # Este método é utilizado nas ações de criação e atualização para garantir
  # que apenas os parâmetros especificados sejam aceitos.
  #
  # Parâmetros permitidos:
  # - :nome - Nome do template.
  # - :questaos_attributes - Atributos das questões associadas ao template.
  # - :alternativas_attributes - Atributos das alternativas associadas às questões.
  def template_params
    params.require(:template).permit(
      :nome,
      questaos_attributes: [
        :id, :pergunta, :tipo_id, :_destroy,
        alternativas_attributes: [:id, :texto, :_destroy]
      ]
    )
  end
end
