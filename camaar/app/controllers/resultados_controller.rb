class ResultadosController < ApplicationController
  before_action :set_resultado, only: [:edit, :update]
  def new
    @formulario = Formulario.find(params[:formulario_id])
    @resultado = Resultado.new(formulario: @formulario)
  end

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

  def edit
    @formulario = @resultado.formulario
    @template = @formulario.template
    @questaos = @template.questaos
  end

  def update
    @formulario = @resultado.formulario
    @template = @formulario.template

    @template.questaos.each do |questao|
      if questao.tipo.discursiva
        resposta_discursiva = params[:respostas_discursivas][questao.id.to_s]
        @resultado.update(respostas_discursivas: @resultado.respostas_discursivas + "###" + resposta_discursiva)
      else
        alternativa_ids = params[:alternativas_ids] || []
        alternativa_ids.each do |id|
          resultado = Resultado.find_or_create_by(
            formulario: @formulario,
            template: @template,
            questao: questao,
            alternativa_id: id
          )
          @resultado.update(respostas: @resultado.respostas + 1)
        end
      end
    end

    respondentes = @formulario.respondentes
    respondentes += ", " + current_user.nome
    @formulario.update(respondentes: respondentes)

    redirect_to home_dicente_url, notice: "Formulário respondido com sucesso."
  end

  private
  def set_resultado
    @resultado = Resultado.find(params[:id])
  end

  def resultado_params
    params.require(:resultado).permit(:formulario_id, :template_id, :questao_id, :alternativa_id, :quantidade_respostas, :respostas_discursivas)
  end
end
