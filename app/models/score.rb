class Score < ApplicationRecord
  belongs_to :evaluator, class_name: 'User', foreign_key: 'evaluator_id'
  belongs_to :user
end
