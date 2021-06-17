class QuestionsController < ApplicationController
  include QuestionsHelper
  
  
  
  
  def start
  end
  
  def start_quiz
    
    unless params[:categories]
      flash[:categories_notice] = "You need to select at least 1 option from categories"
      return redirect_to start_questions_path
    end
    set_settings(params[:limit], params[:difficulty], params[:categories])
    
    
    
    ids = default_categories.map do |category|
      QuizAPI.api_response(category, default_difficulty, default_limit).map do |hash|
        q = create_question(hash)
        ['a','b','c','d','e','f'].each { |char| create_answer(q, hash, char) }
        q.question_id
        
      end
    end
    ids = ids.flatten.uniq.shuffle[0...default_limit]
    
    unless ids.count == default_limit
      flash[:categories_notice] = "You have selected options which don't have seeded 
      data in the database (not provided by api). Try without selecting 'Linux' or 'DevOps'"
      return redirect_to start_questions_path
    end
    
    # we want to retrieve the api question id in session for future reference
    set_quiz(ids)
    # Question.destroy_all
    redirect_to question_path(current_index)
  end
  
  
  
  
  
  
  
  

  def show
    if !correct_index(params[:id]) && !more_questions?
      redirect_to question_path(current_index)
    end
     @question = Question.find_by(question_id: question_id(current_index-1))
    
  end
  
  def submit
    missing_answer = params[:options].nil?
    
    if missing_answer
      flash[:notice] = "You need to select atleast one option"
      return redirect_to question_path(current_index)
    end
    
    add_answer_ids(params[:options]) 
    redirect_to more_questions? ? question_path(next_index) : finish_questions_path
  end
  
  
  
  
  
  

  
  
  
  
  

  def finish
    if more_questions?
      return redirect_to question_path(current_index)
    end
    @correct_questions = 0
    answer_ids.count.times do |i|
      @question = Answer.find_by(id: answer_ids[0]).question
      correct_answers  = @question.answers.where(correct: true).count
      correct_selected = Answer.where(id: answer_ids[i-1], correct: true).count
      
      @correct_questions += 1 if correct_answers == correct_selected
    end
    @total_questions = question_ids.count
    
    @history = history
    log_history(@correct_questions, @total_questions, DateTime.now.strftime("%d/%m/%Y %H:%M"))
  end

  # start from the beginning
  def reload
    Question.where(id: question_ids).destroy_all
    destroy_quiz
    redirect_to start_questions_path
  end
  
  # redo same test
  def repeat
    repeat_quiz
    redirect_to question_path(current_index)
  end
  
  
  
  
  
  
  
  
  
  
  private 
  
  
  def create_question(hash)
    
    Question.create(
      question_id: hash["id"],
      title: hash["question"],
      category: hash["category"],
      description: hash["description"],
      difficulty: hash["difficulty"],
      multiple_correct_answers: hash["multiple_correct_answers"] == "true" # not relied on in the assignment
    )
  end
  
  def create_answer(question, hash, char)
    correct_str = hash['correct_answers']["answer_#{char}_correct"]
    option = hash['answers']["answer_#{char}"]
    Answer.create(
      question: question,
      option: option,
      # if it doesn't match exactly it's false
      correct: correct_str == "true"  
    )
  end

end
