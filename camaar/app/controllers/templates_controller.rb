class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # GET /templates
  def index
    @templates = Template.all
  end

  # GET /templates/1
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
    questao = @template.questaos.build
    questao.alternativas.build
  end

  # GET /templates/1/edit
  def edit
    @template.questaos.build if @template.questaos.empty?
    @template.questaos.each do |questao|
      questao.alternativas.build if questao.alternativas.empty?
    end
  end

  # POST /templates
  def create
    @template = Template.new(template_params)
    @template.docente = Docente.find_by(user_id: current_user.id)

    if @template.save
      redirect_to home_docente_url, notice: 'Template was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /templates/1
  def update
    if @template.update(template_params)
      redirect_to @template, notice: 'Template was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /templates/1
  def destroy
    @template.destroy
    redirect_to home_docente_url, notice: 'Template was successfully destroyed.'
  end

  private

    def set_template
      @template = Template.find(params[:id])
    end

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
