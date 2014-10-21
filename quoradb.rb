require 'singleton'
require 'sqlite3'
require_relative 'user'
require_relative 'question'
require_relative 'question_follower'
require_relative 'question_like'
require_relative 'reply'

class QuoraDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('quora.db')  # doesn't exist yet
  
    self.results_as_hash = true
    
    self.type_translation = true
  end
end

puts "USERS"
p User.all
puts "QUESTIONS"
p Question.all
puts "REPLIES"
p Reply.all
puts "QUESTION FOLLOWERS"
p QuestionFollower.all
puts "QUESTION LIKES"
p QuestionLike.all

#bob = User.new()
#question = Question.new()
follower1 = QuestionFollower.new({'question_id' => 2, 'follower_id' => 1})
follower2 = QuestionFollower.new({'question_id' => 2, 'follower_id' => 2})
follower3 = QuestionFollower.new({'question_id' => 2, 'follower_id' => 3})

p QuestionFollower.most_followed_questions(2)
#p QuestionFollower.followed_questions_for_user_id(4)
# puts "FOLLOWED QUESTIONS FOR USER 4"
# p QuestionFollower.followed_questions_for_user_id(1)



