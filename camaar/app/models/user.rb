class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable
  after_create :send_set_password_instructions
  enum role: {dicente: 0, docente: 1}

  has_one :docente
  has_one :dicente

  validates :nome, presence: true
  validates :email, presence: true
  validates :usuario, presence: true
  validates :formacao, presence: true

  private

  def send_set_password_instructions
    token = set_reset_password_token
    send_reset_password_instructions(token)
  end

  def set_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token = enc
    self.reset_password_sent_at = Time.now.utc
    self.save(validate: false)
    raw
  end

  def send_reset_password_instructions(token)
    Devise::Mailer.reset_password_instructions(self, token).deliver_now
  end
  
end
