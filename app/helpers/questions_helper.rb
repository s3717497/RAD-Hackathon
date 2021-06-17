module QuestionsHelper
    
    # view method, check if it's been checked in the previous quiz
    def default_category?(category)
        default_categories.include?(category)
    end
    
    def default_limit
        cookies[:limit] ? JSON.parse(cookies[:limit]) : 5
    end
    
    def default_difficulty
        cookies[:difficulty] ? JSON.parse(cookies[:difficulty]) : Question.difficulties.first
    end
    
    def default_categories
        cookies[:categories] ? JSON.parse(cookies[:categories]) : Question.categories
    end
    
    def set_settings(limit, difficulty, categories)
        cookies[:limit] = JSON.generate(limit.to_i)
        cookies[:difficulty] = JSON.generate(difficulty)
        cookies[:categories] = JSON.generate(categories)
    end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    # haven't used sessions because it seems that all data needs to be persisted on the browser
    def destroy_quiz
        cookies.delete(:question_ids)
        cookies.delete(:answer_ids)
        cookies.delete(:current_question_index)
    end
    
    def set_quiz(ids)
        cookies[:question_ids] = JSON.generate(ids)
        repeat_quiz
    end
    
    def repeat_quiz
        # cookies of question ids unchanged
        cookies[:answer_ids] = JSON.generate([])
        cookies[:current_question_index] = JSON.generate(1)
        cookies[:history] ||= JSON.generate([])
    end
    
    def question_ids
        JSON.parse(cookies[:question_ids])
    end
    
    def settings
        settings = 
        {
          difficulty: "Hard",
          categories: ["Linux"],
          total_questions: 5
        }
        cookies[:settings] ? JSON.parse(cookies[:settings]) : settings
        
    end
    
    
    def question_id(index)
        question_ids[index]
        # what if incorrect index
    end
    
    
    
    
    
    # stores array of array of ids
    # [["33"],["343"],["342","3432"]]
    def add_answer_ids(ids)
        cookies[:answer_ids] = JSON.generate(answer_ids + [ids])
        puts "\n\n\nOPTION IDS #{answer_ids}\n\n\n"
    end
    
    def answer_ids
        JSON.parse(cookies[:answer_ids])
    end
    
    
    
    
    
    
    
    
    def more_questions?
        current_index && current_index < question_ids.count
    end
    
    def correct_index(param_id)
        params[:id].to_i == current_index
    end
    
    def current_index
        JSON.parse(cookies[:current_question_index])
    end
    
    def next_index
        cookies[:current_question_index] = JSON.generate(current_index + 1)
    end
    
    
    def log_history(correct_questions, total_questions, date)
        latest_log = "Acheived #{correct_questions}/#{total_questions} questions on #{date}"
        full_history = [latest_log] + history
        full_history = full_history.take(5) if history.count >= 5
        cookies[:history] = JSON.generate(full_history)
    end
    
    def history
        JSON.parse(cookies[:history])
    end
end
