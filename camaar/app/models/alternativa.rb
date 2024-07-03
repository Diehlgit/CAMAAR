class Alternativa < ApplicationRecord
  belongs_to :questao, optional: true
  has_and_belongs_to_many :resultados, join_table: 'resultados'

  validates :texto, presence: true
end
