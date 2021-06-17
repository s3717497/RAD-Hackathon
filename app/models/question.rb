class Question < ApplicationRecord
    has_many :answers, dependent: :destroy
    validates :title, presence: true
    validates :question_id, presence: true, uniqueness: true
    #description
    # so nil values get converted to false
    before_save {self.multiple_correct_answers ||= false}
    #explanation
    
    # case sensitive enums and difficulty?
    
    def self.categories
        ["Linux", "DevOps", "Networking", "Programming", "Cloud"]
    end
    
    def self.difficulties
        ["Easy", "Medium", "Hard"]
    end
end
