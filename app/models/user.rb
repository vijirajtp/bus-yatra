class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable

  ## Associations
  has_many :bookings, dependent: :destroy

  ## Enumerators
  enum :role, { admin: 0, operator: 1, customer: 2 }
end
