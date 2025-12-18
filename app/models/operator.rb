class Operator < ApplicationRecord
  ## Assocations
  belongs_to :user
  has_many :buses, dependent: :destroy
end
