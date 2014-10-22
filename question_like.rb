class QuestionLike
  def self.all
    results = QuoraDatabase.instance.execute('SELECT * FROM question_likes')
    results.map { |result| QuestionLike.new(result)}
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
  
  attr_accessor :user_id, :question_id
  
  def initialize(question_like_hash = {})
    @question_id = question_like_hash['question_id']
    @user_id = question_like_hash['user_id']
  end
  
  def create
    if QuestionLike.all.include?(
        Questionlike.new({"question_id" => question_id,"user_id" => user_id })
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