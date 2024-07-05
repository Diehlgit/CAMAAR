##
# Controller responsável pelas ações relacionadas aos formulários.
class FormulariosController < ApplicationController
  before_action :set_formulario, only: [:show, :edit, :update, :destroy]
  before_action :set_turmas_and_templates, only: [:new, :create]

  ##
  # GET /formularios
  # Ação para exibir todos os formulários.
  def index
    @formularios = Formulario.all
  end

  def show
  end

  ##
  # GET /formularios/new
  # Ação para exibir o formulário de criação de um novo formulário.
  def new
    @formulario = Formulario.new
  end

  def edit
  end

  ##
  # POST /formularios
  # Ação para criar um novo formulário.
  def create
    @formulario = Formulario.new(formulario_params)

    if @formulario.save
      criar_resultados_formulario(@formulario)
      redirect_to @formulario, notice: 'Formulário foi criado com sucesso.'
    else
      render :new, notice: "Erro ao criar o formulário."
    end
  end

  ##
  # PATCH/PUT /formularios/1
  # Ação para atualizar os dados de um formulário existente.
  def update
    if @formulario.update(formulario_params)
      redirect_to @formulario, notice: 'Formulário foi atualizado com sucesso.'
    else
      @templates = Template.all
      render :edit
    end
  end

  ##
  # DELETE /formularios/1
  # Ação para excluir um formulário existente.
  def destroy
    @formulario.destroy
    redirect_to formularios_url, notice: 'Formulário foi excluído com sucesso.'
  end

  private
    ##
    # Método para buscar e configurar o formulário específico a partir do parâmetro ID.
    def set_formulario
      @formulario = Formulario.find(params[:id])
    end

    ##
    # Método para definir os parâmetros permitidos para criar ou atualizar um formulário.
    def formulario_params
      params.require(:formulario).permit(:nome, :docente_id, :template_id, :dataDeTermino, :respondentes, turma_ids: [])
    end

    ##
    # Método para configurar as variáveis @turmas e @templates necessárias para a criação de um novo formulário.
    # Busca as turmas e templates associados ao docente atualmente logado.
    def set_turmas_and_templates
      @docente = current_user.docente
      if @docente.present?
        @turmas = @docente.turmas
        @templates = @docente.templates
      else
        @turmas = []
        @templates = []
      end
    end

    ##
    # Método para criar resultados para cada questão de um formulário recém-criado, inicializando as respostas.
    def criar_resultados_formulario(formulario)
      template = formulario.template
      template.questaos.each do |questao|
        questao.alternativas.each do |alternativa|
          Resultado.create!(
            formulario: formulario,
            template: template,
            questao: questao,
            alternativa: alternativa,
            quantidade_respostas: 0,
            respostas_discursivas: "aluno, "
          )
        end
      end
    end
end
