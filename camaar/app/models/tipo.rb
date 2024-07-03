class Tipo < ApplicationRecord
  validates :nome, presence: true
  validates :numeroDeAlternativas, presence: true
  validates :discursiva, presence: true
end
