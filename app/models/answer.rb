class Answer < ApplicationRecord
  belongs_to :question
  
# may allow null options
  validates :option, presence: true
  
  before_save { self.correct ||= false }
end
