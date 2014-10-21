class QuestionFollower
  def self.most_followed_questions(n)
    results = QuoraDatabase.instance.execute(<<-SQL)
      SELECT question_id
      FROM question_followers
      GROUP BY question_id
      ORDER BY COUNT(follower_id) DESC
    SQL
    # fetches n most followed questions
    results[0...n].map { |result| Question.find_by_id(result['question_id']) }
  end

  def self.followers_for_question_id(question_id)
    results = QuoraDatabase.instance.execute(<<-SQL, question_id)
      SELECT id
      FROM question_followers
      LEFT JOIN users ON users.id = question_followers.follower_id
      WHERE question_followers.question_id = (?)

    SQL
    
    results.map { |result| User.find_by_id(result['id'])}
  end
  
  def self.followed_questions_for_user_id(user_id)
    results = QuoraDatabase.instance.execute(<<-SQL, user_id)
    SELECT id
    FROM question_followers
    LEFT JOIN questions
     ON questions.id = question_followers.question_id
     WHERE question_followers.follower_id = (?)
    
    SQL
    
    results.map { |result| Question.find_by_id(result['id'])}
  end
  
  

  def self.all
    results = QuoraDatabase.instance.execute('SELECT * FROM question_followers')
    results.map { |result| QuestionFollower.new(result) }
  end
  
  attr_accessor :question_id, :follower_id
  
  def initialize(question_follower_hash = {})
    @question_id = question_follower_hash['question_id']
    @follower_id = question_follower_hash['follower_id']
  end
  
  def == other_questionFollower
    question_id == other_questionFollower.question_id && 
      follower_id == other_questionFollower.follower_id
  end
  
  def create
    if QuestionFollower.all.include?(QuestionFollower.new({"question_id" =>               question_id, "follower_id" => follower_id}))
      raise "You can't follow a question twice, mortal!" 
    end
    
    params = [self.question_id, self.follower_id]
    QuoraDatabase.instance.execute(<<-SQL, *params)
    INSERT INTO
      question_followers (question_id, follower_id)
    VALUES
      (?, ?)
      
    SQL
  end
  
end
