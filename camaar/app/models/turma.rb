##
# turma de uma disciplina
class Turma < ApplicationRecord
  belongs_to :disciplina
  belongs_to :docente

  has_and_belongs_to_many :dicentes, join_table: 'turmas_dicentes'
  has_and_belongs_to_many :formularios, dependent: :destroy, join_table: 'formularios_turmas'

  validates :class_code, presence: true;
  validates :semestre, presence: true;
  validates :codigo, presence: true;

end
