# simple model class that is just static calls for api methods
class QuizAPI
    

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
    
    
end