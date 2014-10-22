class QuestionLike
  def self.all
    results = QuoraDatabase.instance.execute('SELECT * FROM question_likes')
    results.map { |result| QuestionLike.new(result)}
  end
  
  def self.liked_questions_for_user_id(user_id)
    results = QuoraDatabase.instance.execute(<<-SQL, user_id)
      SELECT id, title, body, author_id
      FROM question_likes
      JOIN questions ON question_likes.question_id = questions.id
      WHERE question_likes.user_id = (?)
    
    SQL
    results.map { |result| Question.new({'id' => result['id'],
      'title' => result['title'], 'body' => result['body'], 'author_id' => 
      result['author_id'] } ) }
  end
  
  def self.likers_for_question_id(question_id)
    results = QuoraDatabase.instance.execute(<<-SQL, question_id)
      SELECT id, fname, lname
      FROM question_likes
      JOIN users ON question_likes.user_id = users.id
      WHERE question_likes.question_id = (?)
    SQL
    results.map { |result| User.new({'id' => result['id'],
      'fname' => result['fname'], 'lname' => result['lname'] } ) }
  end
  
  def self.most_liked_questions(n)
    results = QuoraDatabase.instance.execute(<<-SQL)
      SELECT id, title, body, author_id
      FROM question_likes
      JOIN questions ON question_id = id
      GROUP BY question_id
      ORDER BY COUNT(user_id) DESC
    SQL
    #now take n most
    results[0...n].map { |result| Question.new(result) }
  end
  
  def self.num_likes_for_question_id(question_id)
    results = QuoraDatabase.instance.execute(<<-SQL, question_id)
      SELECT COUNT(user_id)
      FROM question_likes
      WHERE question_id = (?)
      GROUP BY question_id
    
    SQL
    return results[0]["COUNT(user_id)"]
  end
  
  attr_accessor :user_id, :question_id
  
  def initialize(question_like_hash = {})
    @question_id = question_like_hash['question_id']
    @user_id = question_like_hash['user_id']
  end
  
  def == other_questionLike
    question_id == other_questionLike.question_id && 
    user_id == other_questionLike.user_id
  end
  
  def create
    if QuestionLike.all.include?(
        QuestionLike.new({"question_id" => question_id,"user_id" => user_id })
      )
      raise "Hey you can't like something twice that is illegal" 
    end
    
    params = [self.question_id, self.user_id]
    QuoraDatabase.instance.execute(<<-SQL, *params)
    INSERT INTO
      question_likes (question_id, user_id)
    VALUES
      (?, ?)
    
    SQL
    
  end
  
end