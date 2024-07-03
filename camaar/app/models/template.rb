class Template < ApplicationRecord
  belongs_to :docente
  has_many :questaos, class_name: 'Questao', foreign_key: :template_id, dependent: :destroy, inverse_of: :template
  accepts_nested_attributes_for :questaos, reject_if: :all_blank, allow_destroy: true

  has_and_belongs_to_many :resultados, join_table: 'resultados'

  validates :nome, presence: true
end
