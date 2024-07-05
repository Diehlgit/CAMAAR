class AlternativasController < ApplicationController
  before_action :set_template
  before_action :set_questao
  before_action :set_alternativa, only: [:edit, :update, :destroy]

  # GET /alternativas
  def index
    @alternativas = @questao.alternativas
  end

  # GET /alternativas/1
  def show
  end

  # GET /alternativas/new
  def new
    @alternativa = @questao.alternativas.build
  end

  # GET /alternativas/1/edit
  def edit
  end

  # POST /alternativas
  def create
    @alternativa = @questao.alternativas.build(alternativa_params)

    if @alternativa.save
      redirect_to edit_template_path(@template), notice: 'Alternativa was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /alternativas/1
  def update
    if @alternativa.update(alternativa_params)
      redirect_to edit_template_path(@template), notice: 'Alternativa was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /alternativas/1
  def destroy
    @alternativa.destroy
    redirect_to edit_template_path(@template), notice: 'Alternativa deletada com sucesso.'
  end

  private
    def set_template
      @template = Template.find(params[:template_id])
    end

    def set_questao
      @questao = Questao.find(params[:questao_id])
    end


    def set_alternativa
      @alternativa = Alternativa.find(params[:id])
    end

    def alternativa_params
      params.require(:alternativa).permit(:texto, :questao_id)
    end
end
