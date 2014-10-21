require_relative 'quoradb.rb'

class QuestionFollower
  def self.most_followed_questions(n)
    
  end

  def self.followers_for_question_id(question_id)
    results = QuoraDatabase.instance.execute(<<-SQL, question_id)
    SELECT id
    FROM users 
    JOIN question_followers ON users.id = question_followers.follower_id
    WHERE question_followers.question_id = (?)

    SQL
    
    results.each { |result| User.find_by_id(result['id'])}
  end
  
  def self.followed_questions_for_user_id(user_id)
    results = QuoraDatabase.instance.execute(<<-SQL, user_id)
    SELECT question_id
    FROM question 
    JOIN question_followers ON questions.id = question_followers.question_id
    
    SQL
    
    results.each { |result| Questions.find_by_id(result['question_id'])}
  end
  
  

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