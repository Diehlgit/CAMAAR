class Questao < ApplicationRecord
  belongs_to :template, optional: true
  belongs_to :tipo
  has_many :alternativas, class_name: 'Alternativa', foreign_key: :questao_id, dependent: :destroy, inverse_of: :questao
  accepts_nested_attributes_for :alternativas, reject_if: :all_blank, allow_destroy: true

  has_and_belongs_to_many :resultados, join_table: 'resultados'

  validates :pergunta, presence: true
end
