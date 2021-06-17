# simple model class that is just static calls for api methods
class QuizAPI
    
    

    
    # # using the http gem, we can simplify the basic auth process 
    # def self.api_response(category = "Linux", limit = 4, difficulty = "Hard")
    #     query = 
    #     {
    #         apiKey: "LHeXoRLVUs7zlu5eVB10pfgIMn4SLRSaw0n2Qv3s",
    #         category: category,
    #         limit: limit,
    #         difficulty: difficulty
    #     }                                                   # TODO multiple categories 
    #     url = "https://quizapi.io/api/v1/questions"
    #     resp = HTTP.get(url, params: query)
    #     hash_array(resp, resp.status.success?, category, limit, difficulty)
    # end
    
    
    #     # using the http gem, we can simplify the basic auth process 
    # def self.hash_array(settings)
    #     categories = settings.delete('categories') 
        
    #     categories.map do |category|
    #         settings['category'] = category
    #         settings['apiKey'] = "LHeXoRLVUs7zlu5eVB10pfgIMn4SLRSaw0n2Qv3s"
            
    #         url = "https://quizapi.io/api/v1/questions"
    #         resp = HTTP.get(url, params: settings)
    #         valid_response = resp.status.success?
            
    #         if valid_response
    #             JSON.parse resp.body
    #         else
    #             break
    #         end
    #     end
        
        
    #     root = Rails.root.to_s
    #     hash_array = JSON.load(File.open("#{root}/quiz.json"))
    # end
    
    # # using the http gem, we can simplify the basic auth process 
    def self.api_response(category, difficulty, limit)
        query = 
        {
            apiKey: "LHeXoRLVUs7zlu5eVB10pfgIMn4SLRSaw0n2Qv3s",
            category: category,
            limit: limit,
            difficulty: difficulty
        }                                                    
        url = "https://quizapi.io/api/v1/questions"
        resp = HTTP.get(url, params: query)
        
        resp.status.success? ? JSON.parse(resp.body) : json_file_response(category, difficulty, limit)
    end
    
    
    private
    
    def self.json_file_response(category, difficulty, limit)
        root = Rails.root.to_s
        hash_array = JSON.load(File.open("#{root}/quiz.json"))
        hash_array.select! {|hash| hash['difficulty'] == difficulty}
        hash_array.select! {|hash| hash['category'] == category}
        hash_array[0...limit]
    end
    
    # converts json data to hash_array
    def self.hash_array(resp, valid_response, category, limit, difficulty)
        if valid_response
            JSON.parse resp.body
        else
            root = Rails.root.to_s
            hash_array = JSON.load(File.open("#{root}/quiz.json"))
        end
    end
    
#     def question(hash)
#         Question.new(
#           question_id: hash["id"],
#           title: hash["question"],
#           category: hash["category"],
#           description: hash["description"],
#           difficulty: hash["difficulty"],
#           multiple_correct_answers: hash["multiple_correct_answers"] == "true" 
#         )
#     end
  
#   def answer(question, hash, char)
#     correct_str = hash['correct_answers']["answer_#{char}_correct"]
#     option = hash['answers']["answer_#{char}"]
#     Answer.new(
#       question: question,
#       option: option,
#       # if it doesn't match exactly it's false
#       correct: correct_str == "true"  
#     )
#   end
end