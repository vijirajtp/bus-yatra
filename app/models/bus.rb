class Bus < ApplicationRecord
  ## Assocations
  belongs_to :operator

  ## Enumerators
  enum :bus_type, { ac_seater: 0, ac_sleeper: 1, non_ac_seater: 2, non_ac_sleeper: 3 }
end
