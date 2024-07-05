##
# controller responsavel pelas acoes relacionadas as questoes dos formularios
class QuestaosController < ApplicationController
  before_action :get_template
  before_action :set_questao, only: [:show, :edit, :update, :destroy]

  ##
  # GET /questaos
  def index
    @questaos = @template.questaos
  end

  ##
  # GET /questaos/new
  def new
    @questao = @template.questaos.build
    @tipos = Tipo.all
  end

  def show

  end

  ##
  # GET /questaos/1/edit
  def edit

  end

  ##
  # POST /questaos
  def create
    @questao = @template.questaos.build(questao_params)

    if @questao.save
      ##
      #redirect_to @questao, notice: 'Questao was successfully created.'
      redirect_to edit_template_path(@template)
    else
      render :new
    end
  end

  ##
  # PATCH/PUT /questaos/1
  def update
    if @questao.update(questao_params)
      redirect_to @template, notice: 'Questao was successfully updated.'
    else
      render :edit
    end
  end

  ##
  # DELETE /questaos/1
  def destroy
    if @questao.destroy
      redirect_to edit_template_path(@template), notice: 'Questão excluída com sucesso.'
    else
      redirect_to edit_template_path(@template), alert: 'Erro ao excluir a questão.'
    end
  end

  private
    def get_template
      @template = Template.find(params[:template_id])
    end

    def set_questao
      @questao = @template.questaos.find(params[:id])
    end

    def questao_params
      params.require(:questao).permit(:pergunta, :template_id, :tipo_id, alternativas_attributes: [:id, :texto, :_destroy])
    end
end
