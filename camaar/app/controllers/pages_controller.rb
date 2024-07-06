##
# Controller responsável pelas ações relacionadas às páginas.
class PagesController < ApplicationController
  ##
  # Ação para exibir a página inicial do usuário do tipo dicente.
  #
  # Esta ação busca o registro do dicente associado ao usuário atualmente logado.
  # Se um dicente for encontrado, busca todas as turmas associadas a esse dicente
  # através da relação TurmasDicente. Se não houver turmas associadas, define @turmas
  # como uma lista vazia.
  def home_dicente
    @dicente = Dicente.find_by(user_id: current_user.id)
    if @dicente.present?
      @turmas = TurmasDicente.where(dicente_id: @dicente.id).includes(turma: :formularios).map(&:turma)
      @turmas = [] unless @turmas.present?
    else
      @turmas = []
    end
  end

  ##
  # Ação para exibir a página inicial do usuário do tipo docente.
  #
  # Esta ação busca o registro do docente associado ao usuário atualmente logado.
  # Se um docente for encontrado, busca todas as turmas associadas a esse docente
  # através da relação Turma. Também busca os templates associados a esse docente.
  # Além disso, busca os formulários associados às turmas do docente, acessando
  # os formulários de cada turma através da relação entre Turma e Formulario.
  #
  # Se nenhum docente for encontrado, define @turmas, @templates e @formularios
  # como listas vazias.
  def home_docente
    @docente = Docente.find_by(user_id: current_user.id)
    if @docente.present?
      @turmas = Turma.where(docente_id: @docente.id)
      @templates = Template.where(docente_id: @docente.id)
      @formularios = @turmas.flat_map { |turma| turma.formularios }
    else
      @turmas = []
      @templates = []
      @formularios = []
    end
  end
end
