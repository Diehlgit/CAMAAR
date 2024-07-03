class Formulario < ApplicationRecord
  belongs_to :docente
  belongs_to :template

  has_and_belongs_to_many :turmas, join_table: 'formularios_turmas'
  has_many :resultados
  #has_and_belongs_to_many :resultados, join_table: 'resultados'

  validates :dataDeTermino, presence: true
  validates :nome, presence: true
  validates :respondentes, presence: true

  validate :dataDeTermino_in_future

  private

  def dataDeTermino_in_future
    if dataDeTermino && dataDeTermino <= Date.today
      errors.add(:dataDeTermino, "deve ser uma data futura")
    end
  end
end
