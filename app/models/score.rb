class Score < ApplicationRecord
  belongs_to :evaluator
  belongs_to :user
end
