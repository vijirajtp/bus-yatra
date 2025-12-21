class Operator < ApplicationRecord
  ## Assocations
  belongs_to :user
  has_many :buses, dependent: :destroy

  ## Scopes
  scope :desc, -> { order('created_at DESC') }

  ## Validations
  validates :name, presence: true
end
