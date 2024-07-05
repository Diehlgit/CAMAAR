##
# Tipo de questao: confirmacao, multipla escolha, satisfacao ou aberta
class Tipo < ApplicationRecord
  validates :nome, presence: true
  validates :numeroDeAlternativas, presence: true
  validates :discursiva, presence: true
end
