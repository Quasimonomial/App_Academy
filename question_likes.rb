require_relative 'quoradb.rb'

class QuestionLike
  def self.all
    results = QuoraDatabase.instance.execute('SELECT * FROM question_likes')
    results.map { |result| QuestionLike.new(result)}
  end
  
  attr_accessor :user_id, :question_id
  
  def initialize(question_like_hash = {})
    @question_id = question_like_hash['question_id']
    @follower_id = question_like_hash['follower_id']
  end
  
end