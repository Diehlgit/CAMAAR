##
# Controller responsável pelas ações relacionadas à turma.
class TurmasController < ApplicationController
  # Define a turma antes de executar as ações :show, :edit, :update, e :destroy.
  before_action :set_turma, only: [:show, :edit, :update, :destroy]

  ##
  # GET /turmas
  # Ação para listar todas as turmas.
  #
  # Esta ação busca todos os registros de turmas na base de dados e os
  # armazena na variável de instância @turmas para serem exibidos na visão correspondente.
  def index
    @turmas = Turma.all
  end

  ##
  # GET /turmas/:id
  # Ação para exibir uma turma específica.
  #
  # Esta ação utiliza o before_action :set_turma para buscar a turma com o ID
  # fornecido nos parâmetros e armazená-la na variável de instância @turma
  # para ser exibida na visão correspondente.
  #
  # Parâmetros:
  # - :id - O ID da turma a ser exibida.
  def show
  end

  ##
  # GET /turmas/new
  # Ação para inicializar uma nova turma.
  #
  # Esta ação cria uma nova instância de turma e busca todas as disciplinas e
  # docentes para serem utilizados no formulário de criação de turma.
  def new
    @turma = Turma.new
    @disciplinas = Disciplina.all
    @docentes = User.where(type: 'Docente')
  end

  ##
  # GET /turmas/:id/edit
  # Ação para editar uma turma existente.
  #
  # Esta ação utiliza o before_action :set_turma para buscar a turma com o ID
  # fornecido nos parâmetros e busca todas as disciplinas e docentes para
  # serem utilizados no formulário de edição.
  #
  # Parâmetros:
  # - :id - O ID da turma a ser editada.
  def edit
    @disciplinas = Disciplina.all
    @docentes = User.where(type: 'Docente')
  end

  ##
  # POST /turmas
  # Ação para criar uma nova turma.
  #
  # Esta ação inicializa uma nova instância de turma com os parâmetros
  # permitidos, tenta salvá-la na base de dados e, se bem-sucedida,
  # redireciona para a página de exibição da turma recém-criada com uma
  # mensagem de sucesso; caso contrário, renderiza novamente o formulário de criação.
  #
  # Parâmetros:
  # - :turma - Os parâmetros da turma a ser criada.
  def create
    @turma = Turma.new(turma_params)

    if @turma.save
      redirect_to @turma, notice: 'Turma foi criada com sucesso.'
    else
      @disciplinas = Disciplina.all
      @docentes = User.where(type: 'Docente')
      render :new
    end
  end

  ##
  # PATCH/PUT /turmas/:id
  # Ação para atualizar uma turma existente.
  #
  # Esta ação utiliza o before_action :set_turma para buscar a turma com o ID
  # fornecido nos parâmetros, tenta atualizar seus atributos com os
  # parâmetros permitidos e salvá-la na base de dados. Se a atualização for
  # bem-sucedida, redireciona para a página de exibição da turma com uma
  # mensagem de sucesso; caso contrário, renderiza novamente o formulário de edição.
  #
  # Parâmetros:
  # - :id - O ID da turma a ser atualizada.
  # - :turma - Os parâmetros da turma a serem atualizados.
  def update
    if @turma.update(turma_params)
      redirect_to @turma, notice: 'Turma foi atualizada com sucesso.'
    else
      @disciplinas = Disciplina.all
      @docentes = User.where(type: 'Docente')
      render :edit
    end
  end

  ##
  # DELETE /turmas/:id
  # Ação para deletar uma turma existente.
  #
  # Esta ação utiliza o before_action :set_turma para buscar a turma com o ID
  # fornecido nos parâmetros, destrui-la na base de dados e redireciona para a
  # lista de turmas com uma mensagem de sucesso.
  #
  # Parâmetros:
  # - :id - O ID da turma a ser deletada.
  def destroy
    @turma.destroy
    redirect_to turmas_url, notice: 'Turma excluída com sucesso.'
  end

  ##
  # Importa os dados de uma turma a partir de um JSON.
  #
  # Esta ação lê um arquivo JSON fornecido via upload, cria instâncias de
  # usuário (docentes e discentes) e turmas com base nos dados do arquivo e
  # os salva na base de dados. Se a importação for bem-sucedida, retorna uma
  # mensagem de sucesso; caso contrário, retorna um erro.
  #
  # Parâmetros:
  # - :file - O arquivo JSON a ser importado.
  def import
    if request.post?
      file = params[:file]

      if file
        data = JSON.parse(file.read)
        data.each do |class_data|
          instructor_data = class_data['docente']
          user_docente = User.create!(
            nome: instructor_data['nome'],
            email: instructor_data['email'],
            password: 'administrador1234',
            usuario: instructor_data['usuario'],
            formacao: instructor_data['formacao'],
            role: :docente
          )
          Docente.create!(
            user_id: user_docente.id,
            departamento: instructor_data['departamento']
          )

          turma_criada = Turma.find_or_create_by(
            codigo: class_data['code'],
            class_code: class_data['classCode'],
            semestre: class_data['semester'],
            docente: user_docente.docente,
            horario: class_data['time'],
            disciplina: Disciplina.find_by(codigo: class_data['code'] ),
          )
          class_data['dicente'].each do |student_data|
            user_dicente = User.create!(
              nome: student_data['nome'],
              email: student_data['email'],
              password: rand(1_000_000_000...9_000_000_000),
              usuario: student_data['usuario'],
              formacao: student_data['formacao'],
              role: :dicente
            )
            Dicente.create!(
              user_id: user_dicente.id,
              curso: student_data['curso'],
              matricula: student_data['matricula'],
            )
            ##
            # Associa o dicente à turma
            user_dicente.dicente.turmas << turma_criada
          end
        end

        render json: { message: 'Turmas imported successfully' }, status: :ok
      else
        render json: { error: 'No file provided' }, status: :unprocessable_entity
      end
    else
      render :import
    end
  end

  private

  ##
  # Método privado para definir a turma antes de executar as ações :show, :edit, :update, e :destroy.
  #
  # Este método busca a turma com o ID fornecido nos parâmetros e a armazena
  # na variável de instância @turma para ser utilizada nas ações correspondentes.
  #
  # Parâmetros:
  # - :id - O ID da turma a ser buscada.
  def set_turma
    @turma = Turma.find(params[:id])
  end

  ##
  # Método privado para filtrar e permitir apenas os parâmetros permitidos
  # para a turma.
  #
  # Este método é utilizado nas ações de criação e atualização para garantir
  # que apenas os parâmetros especificados sejam aceitos.
  #
  # Parâmetros permitidos:
  # - :class_code - Código da turma.
  # - :semestre - Semestre da turma.
  # - :horario - Horário da turma.
  # - :disciplina_id - ID da disciplina associada.
  # - :docente_id - ID do docente associado.
  def turma_params
    params.require(:turma).permit(:class_code, :semestre, :horario, :disciplina_id, :docente_id)
  end
end
