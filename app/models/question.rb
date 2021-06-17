class Question < ApplicationRecord
    has_many :answers, dependent: :destroy
    validates :title, presence: true
    validates :question_id, presence: true, uniqueness: true
    # so nil values get converted to false
    # not used
    before_save {self.multiple_correct_answers ||= false}
    
    
    def self.categories
        ["Linux", "DevOps", "Networking", "Programming", "Cloud"]
    end
    
    def self.difficulties
        ["Easy", "Medium", "Hard"]
    end
    
    def multiple_correct
        answers.where(correct: true).count >= 2
    end
end
