class Resultado < ApplicationRecord
  belongs_to :formulario
  belongs_to :template
  belongs_to :questao
  belongs_to :alternativa, optional: true

  validates :respostas, presence: true, numericality: { only_integer: true }
  validates :respostas_discursivas, presence: true
end
