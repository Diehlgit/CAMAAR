##
# Controller responsável pelas ações relacionadas às questões dos formulários.
class QuestaosController < ApplicationController
  before_action :get_template
  before_action :set_questao, only: [:show, :edit, :update, :destroy]

  ##
  # GET /templates/:template_id/questaos
  # Ação para listar todas as questões associadas a um template específico.
  #
  # Esta ação busca todas as questões associadas ao template identificado
  # pelo ID fornecido nos parâmetros e as armazena na variável de instância @questaos.
  #
  # Parâmetros:
  # - :template_id - O ID do template ao qual as questões estão associadas.
  def index
    @questaos = @template.questaos
  end

  ##
  # GET /templates/:template_id/questaos/new
  # Ação para inicializar uma nova questão associada a um template específico.
  #
  # Esta ação cria uma nova instância de questão associada ao template identificado
  # pelo ID fornecido nos parâmetros e armazena-a na variável de instância @questao.
  #
  # Parâmetros:
  # - :template_id - O ID do template ao qual a nova questão está associada.
  def new
    @questao = @template.questaos.build
    @tipos = Tipo.all
  end

  def show
  end

  def edit
  end

  ##
  # POST /templates/:template_id/questaos
  # Ação para criar uma nova questão associada a um template específico.
  #
  # Esta ação inicializa uma nova instância de questão com os parâmetros permitidos,
  # tenta salvá-la na base de dados e, se bem-sucedida, redireciona para a edição
  # do template com uma mensagem de sucesso. Caso contrário, renderiza novamente o
  # formulário de criação com os erros.
  #
  # Parâmetros:
  # - :template_id - O ID do template ao qual a nova questão está associada.
  # - :questao - Os parâmetros da questão a ser criada.
  def create
    @questao = @template.questaos.build(questao_params)

    if @questao.save
      # Redireciona para a edição do template com uma mensagem de sucesso.
      redirect_to edit_template_path(@template)
    else
      render :new
    end
  end

  ##
  # PATCH/PUT /templates/:template_id/questaos/:id
  # Ação para atualizar uma questão existente.
  #
  # Esta ação atualiza uma questão específica com os parâmetros permitidos e
  # persiste as alterações na base de dados. Se a atualização for bem-sucedida,
  # redireciona para a exibição do template com uma mensagem de sucesso; caso
  # contrário, renderiza novamente o formulário de edição com os erros.
  #
  # Parâmetros:
  # - :template_id - O ID do template ao qual a questão está associada.
  # - :id - O ID da questão a ser atualizada.
  # - :questao - Os parâmetros da questão a ser atualizada.
  def update
    if @questao.update(questao_params)
      redirect_to @template, notice: 'Questao foi atualizada com sucesso.'
    else
      render :edit
    end
  end

  ##
  # DELETE /templates/:template_id/questaos/:id
  # Ação para excluir uma questão existente.
  #
  # Esta ação exclui uma questão específica e redireciona para a edição do template
  # com uma mensagem de sucesso. Caso a exclusão falhe, redireciona com uma mensagem
  # de erro.
  #
  # Parâmetros:
  # - :template_id - O ID do template ao qual a questão está associada.
  # - :id - O ID da questão a ser excluída.
  def destroy
    if @questao.destroy
      redirect_to edit_template_path(@template), notice: 'Questão excluída com sucesso.'
    else
      redirect_to edit_template_path(@template), alert: 'Erro ao excluir a questão.'
    end
  end

  private

  ##
  # Método privado para buscar o template associado aos parâmetros.
  #
  # Este método é utilizado nas ações para buscar o template identificado
  # pelo ID fornecido nos parâmetros e armazená-lo na variável de instância @template.
  #
  # Parâmetros:
  # - :template_id - O ID do template a ser buscado.
  def get_template
    @template = Template.find(params[:template_id])
  end

  ##
  # Método privado para buscar uma questão específica pelo ID.
  #
  # Este método é utilizado nas ações show, edit, update e destroy para buscar
  # a questão com o ID fornecido nos parâmetros e armazená-la na variável de instância @questao.
  #
  # Parâmetros:
  # - :template_id - O ID do template ao qual a questão está associada.
  # - :id - O ID da questão a ser buscada.
  def set_questao
    @questao = @template.questaos.find(params[:id])
  end

  ##
  # Método privado para filtrar e permitir apenas os parâmetros permitidos para a questão.
  #
  # Este método é utilizado nas ações de criação e atualização para garantir
  # que apenas os parâmetros especificados sejam aceitos.
  #
  # Parâmetros permitidos:
  # - :pergunta - O texto da pergunta da questão.
  # - :template_id - O ID do template ao qual a questão está associada.
  # - :tipo_id - O ID do tipo da questão.
  # - :alternativas_attributes - Os atributos das alternativas associadas à questão.
  def questao_params
    params.require(:questao).permit(:pergunta, :template_id, :tipo_id, alternativas_attributes: [:id, :texto, :_destroy])
  end
end
