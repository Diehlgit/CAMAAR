class PagesController < ApplicationController

  def home_dicente
    @dicente = Dicente.find_by(user_id: current_user.id)
    if @dicente.present?
      @turmas = TurmasDicente.where(dicente_id: @dicente.id).includes(turma: :formularios).map(&:turma)
      if !@turmas.present?
        @turmas = []
      end
    else
      @turmas = []
    end
  end

  def home_docente
    @docente = Docente.find_by(user_id: current_user.id)
    if @docente.present?
      # Busca todas as classes do docente
      @turmas = Turma.where(docente_id: @docente.id)
      @turmas = [] unless @turmas.present?

      # Busca os templates
      @templates = Template.where(docente_id: @docente.id)

      # Aqui você pode acessar os formulários através das classes
      # Exemplo de como acessar os formulários de cada classe:
      @formularios = @turmas.flat_map { |turma| turma.formularios }
    else
      @turmas = []
      @templates = []
      @formularios = []
    end
  end
end
