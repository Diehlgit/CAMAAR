##
# Controller responsável pelas ações relacionadas aos resultados de um formulário.
class ResultadosController < ApplicationController
  before_action :set_resultado, only: [:show, :edit, :update]

  ##
  # GET /formularios/:formulario_id/resultados/new
  # Ação para inicializar um novo resultado associado a um formulário específico.
  #
  # Esta ação cria uma nova instância de resultado associada ao formulário
  # identificado pelo ID fornecido nos parâmetros e armazena-a na variável de
  # instância @resultado.
  #
  # Parâmetros:
  # - :formulario_id - O ID do formulário ao qual o resultado está associado.
  def new
    @formulario = Formulario.find(params[:formulario_id])
    @resultado = Resultado.new(formulario: @formulario)
  end

  ##
  # GET /resultados/:id
  # Ação para exibir um resultado específico.
  #
  # Esta ação é usada para exibir um resultado com o ID fornecido nos parâmetros.
  #
  # Parâmetros:
  # - :id - O ID do resultado a ser exibido.
  def show
  end

  ##
  # POST /resultados
  # Ação para criar um novo resultado.
  #
  # Esta ação inicializa uma nova instância de resultado com os parâmetros
  # permitidos, tenta salvá-la na base de dados e, se bem-sucedida, calcula
  # a nota associada ao resultado e a persiste novamente. Se a criação for
  # bem-sucedida, redireciona para a exibição do resultado com uma mensagem
  # de sucesso; caso contrário, renderiza novamente o formulário de criação
  # com os erros.
  #
  # Parâmetros:
  # - :resultado - Os parâmetros do resultado a ser criado.
  def create
    @resultado = Resultado.new(resultado_params)

    if @resultado.save
      @resultado.calcular_nota
      @resultado.save # Salva novamente para persistir a nota calculada
      redirect_to @resultado, notice: 'Resultado foi criado com sucesso.'
    else
      @formulario = @resultado.formulario
      render :new
    end
  end

  ##
  # GET /resultados/:id/edit
  # Ação para editar um resultado existente.
  #
  # Esta ação busca o resultado com o ID fornecido nos parâmetros e inicializa
  # as variáveis de instância necessárias para o formulário de edição, incluindo
  # o formulário associado, o template do formulário e as questões do template.
  #
  # Parâmetros:
  # - :id - O ID do resultado a ser editado.
  def edit
    @formulario = @resultado.formulario
    @template = @formulario.template
    @questaos = @template.questaos
  end

  ##
  # PATCH/PUT /resultados/:id
  # Ação para atualizar um resultado existente.
  #
  # Esta ação busca o resultado com o ID fornecido nos parâmetros, verifica
  # se o usuário atual já respondeu ao formulário associado, processa as
  # respostas discursivas e alternativas fornecidas nos parâmetros e as
  # persiste na base de dados. Se a atualização for bem-sucedida, redireciona
  # para a página inicial do discente com uma mensagem de sucesso; caso contrário,
  # renderiza novamente o formulário de edição com os erros.
  #
  # Parâmetros:
  # - :id - O ID do resultado a ser atualizado.
  # - :respostas - As respostas fornecidas pelo usuário, incluindo as discursivas
  #                e as alternativas.
  def update
    @formulario = @resultado.formulario
    @template = @formulario.template

    if @formulario.respondentes.include?(current_user.nome)
      flash[:notice] = "Formulário já respondido"
      redirect_to home_dicente_url
    else
      if params[:respostas].present?
        # Processa as respostas discursivas
        if params[:respostas][:discursivas].present?
          params[:respostas][:discursivas].each do |questao_id, resposta|
            resultado = Resultado.find_or_create_by(
              formulario: @formulario,
              template: @template,
              questao_id: questao_id
            )
            resultado.update(respostas_discursivas: (resultado.respostas_discursivas.to_s + "###" + resposta))
          end
        end

        # Processa as respostas alternativas
        if params[:respostas][:alternativas_ids].present?
          params[:respostas][:alternativas_ids].each do |questao_id, alternativa_id|
            resultado = Resultado.find_or_create_by(
              formulario: @formulario,
              template: @template,
              questao_id: questao_id,
              alternativa_id: alternativa_id
            )
            resultado.update(quantidade_respostas: resultado.quantidade_respostas.to_i + 1)
          end
        end

        # Atualiza a lista de respondentes do formulário
        respondentes = @formulario.respondentes
        respondentes += ", " + current_user.nome
        @formulario.update(respondentes: respondentes)

        redirect_to home_dicente_url, notice: "Formulário respondido com sucesso."
      end
    end
  end

  private

  ##
  # Método privado para buscar um resultado específico pelo ID.
  #
  # Este método é utilizado nas ações show, edit e update para buscar o resultado
  # com o ID fornecido nos parâmetros e armazená-lo na variável de instância @resultado.
  #
  # Parâmetros:
  # - :id - O ID do resultado a ser buscado.
  def set_resultado
    @resultado = Resultado.find(params[:id])
  end

  ##
  # Método privado para filtrar e permitir apenas os parâmetros permitidos
  # para o resultado.
  #
  # Este método é utilizado nas ações de criação e atualização para garantir
  # que apenas os parâmetros especificados sejam aceitos.
  #
  # Parâmetros permitidos:
  # - :formulario_id - ID do formulário associado ao resultado.
  # - :template_id - ID do template associado ao resultado.
  # - :questao_id - ID da questão associada ao resultado.
  # - :alternativa_id - ID da alternativa associada ao resultado.
  # - :quantidade_respostas - Quantidade de respostas fornecidas.
  # - :respostas_discursivas - Respostas discursivas fornecidas.
  def resultado_params
    params.require(:resultado).permit(:formulario_id, :template_id, :questao_id, :alternativa_id, :quantidade_respostas, :respostas_discursivas)
  end
end
