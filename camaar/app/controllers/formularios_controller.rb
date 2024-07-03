class FormulariosController < ApplicationController
  before_action :set_formulario, only: [:show, :edit, :update, :destroy]
  before_action :set_turmas_and_templates, only: [:new, :create]

  # GET /formularios
  def index
    @formularios = Formulario.all
  end

  # GET /formularios/1
  def show
  end

  # GET /formularios/new
  def new
    @formulario = Formulario.new
  end

  # GET /formularios/1/edit
  def edit
  end

  # POST /formularios
  def create
    @formulario = Formulario.new(formulario_params)

    if @formulario.save
      criar_resultados_formulario(@formulario)
      redirect_to @formulario, notice: 'Formulário foi criado com sucesso.'
    else
      render :new, notice:"erro ao criar o formulário"
    end
  end

  # PATCH/PUT /formularios/1
  def update
    if @formulario.update(formulario_params)
      redirect_to @formulario, notice: 'Formulário foi atualizado com sucesso.'
    else
      @templates = Template.all
      render :edit
    end
  end

  # DELETE /formularios/1
  def destroy
    @formulario.destroy
    redirect_to formularios_url, notice: 'Formulário foi excluído com sucesso.'
  end

  private
    def set_formulario
      @formulario = Formulario.find(params[:id])
    end

    def formulario_params
      params.require(:formulario).permit(:nome, :docente_id, :template_id, :dataDeTermino, :respondentes, turma_ids: [])
    end

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

    def criar_resultados_formulario(formulario)
      template = formulario.template
      template.questaos.each do |questao|
        questao.alternativas.each do |alternativa|
          Resultado.create!(
            formulario: formulario,
            template: template,
            questao: questao,
            alternativa: alternativa,
            respostas: 0,
            respostas_discursivas: ""
          )
        end
      end
    end
end
