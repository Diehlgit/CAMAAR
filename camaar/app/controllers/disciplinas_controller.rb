##
# Controller responsável pelas ações relacionadas às disciplinas.
class DisciplinasController < ApplicationController
  before_action :set_disciplina, only: [:show, :edit, :update, :destroy]

  ##
  # GET /disciplinas
  # Ação para listar todas as disciplinas cadastradas.
  def index
    @disciplinas = Disciplina.all
  end

  ##
  # GET /disciplinas/1
  # Ação para exibir os detalhes de uma disciplina específica.
  def show
  end

  ##
  # GET /disciplinas/new
  # Ação para exibir o formulário de criação de uma nova disciplina.
  def new
    @disciplina = Disciplina.new
  end

  ##
  # GET /disciplinas/1/edit
  # Ação para exibir o formulário de edição de uma disciplina existente.
  def edit
  end

  ##
  # POST /disciplinas
  # Ação para criar uma nova disciplina com base nos parâmetros recebidos do formulário de criação.
  def create
    @disciplina = Disciplina.new(disciplina_params)

    if @disciplina.save
      redirect_to @disciplina, notice: 'Disciplina foi criada com sucesso.'
    else
      render :new
    end
  end

  ##
  # PATCH/PUT /disciplinas/1
  # Ação para atualizar os dados de uma disciplina existente com base nos parâmetros recebidos do formulário de edição.
  def update
    if @disciplina.update(disciplina_params)
      redirect_to @disciplina, notice: 'Disciplina foi atualizada com sucesso.'
    else
      render :edit
    end
  end

  ##
  # DELETE /disciplinas/1
  # Ação para excluir uma disciplina existente.
  def destroy
    @disciplina.destroy
    redirect_to disciplinas_url, notice: 'Disciplina foi excluída com sucesso.'
  end

  ##
  # POST /disciplinas/import
  # Ação para importar dados de disciplinas a partir de um arquivo JSON.
  def import
    if request.post?
      file = params[:file]

      if file
        data = JSON.parse(file.read)
        data.each do |course_data|
          disciplina = Disciplina.find_or_create_by(
            codigo: course_data['code'],
            nome: course_data['name']
          )

          class_data = course_data['class']
          Turma.find_or_create_by(
            disciplina_id: disciplina.id,
            class_code: class_data['classCode'],
            semestre: class_data['semester'],
            horario: class_data['time'],
            codigo: disciplina.codigo
          )
        end

        render json: { message: 'Courses imported successfully' }, status: :ok
      else
        render json: { error: 'No file provided' }, status: :unprocessable_entity
      end
    else
      render :import
    end
  end

  private
    ##
    # Método para buscar e configurar a disciplina específica a partir do parâmetro ID.
    def set_disciplina
      @disciplina = Disciplina.find(params[:id])
    end

    ##
    # Método para definir os parâmetros permitidos para a criação ou atualização de uma disciplina.
    def disciplina_params
      params.require(:disciplina).permit(:codigo, :nome)
    end
end
