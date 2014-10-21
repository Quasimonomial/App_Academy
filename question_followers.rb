require_relative 'quoradb.rb'

class QuestionFollower
  def self.all
    results = QuoraDatabase.instance.execute('SELECT * FROM question_followers')
    results.map { |result| Question.new(result) }
  end
  
  attr_accessor :question_id, :follower_id
  
  def initalize(question_follower_hash = {})
    @question_id = question_follower_hash['question_id']
    @follower_id = question_follower_hash['follower_id']
  end
end

#for create, we much make sure that we don't already have a question/follower id pair