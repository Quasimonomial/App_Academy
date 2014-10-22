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
liker1 = QuestionLike.new({'question_id' => 1, 'user_id' => 1})
liker2 = QuestionLike.new({'question_id' => 1, 'user_id' => 2})
liker3 = QuestionLike.new({'question_id' => 1, 'user_id' => 3})
liker4 = QuestionLike.new({'question_id' => 2, 'user_id' => 3})


p QuestionLike.num_likes_for_question_id(1)
p QuestionLike.likers_for_question_id(1)
puts
p "moar things"
puts
QuestionLike.liked_questions_for_user_id(3).each do |relationship|
  p relationship
end
puts "I'm sure this will work"
p User.all[2].liked_questions
