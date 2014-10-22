class User
  def self.all
    results = QuoraDatabase.instance.execute('SELECT * FROM users')
    results.map { |result| User.new(result) }
  end
  
  def self.find_by_id user_id
    results = QuoraDatabase.instance.execute(<<-SQL, user_id)
      SELECT *
      FROM users
      WHERE id = (?)
    
    SQL
    #results["id"] = results["id"].to_i
    User.new(results[0])
  end
  
  def self.find_by_name fname, lname
    params = [fname, lname]
    results = QuoraDatabase.instance.execute(<<-SQL, *params)
      SELECT *
      FROM users
      WHERE 
        fname = (?) AND lname = (?)
    SQL
    return results
  end
  
    
  attr_accessor :id, :fname, :lname
  
  def initialize(user_hash = {})
    @id = user_hash['id']
    @fname = user_hash['fname']
    @lname = user_hash['lname']
  end
  
  def average_karma
    results = QuoraDatabase.instance.execute(<<-SQL, id)
    SELECT COUNT(user_id)
    FROM question_likes 
    JOIN question_query ON id = question_id
    (SELECT questions.id
    FROM questions 
    LEFT OUTER JOIN question_likes ON id = question_id
    WHERE question.author_id = ( ? )
    AS question_query)
    
    SQL
    
    #     SELECT COUNT(user_id)
    # FROM question_likes
    # WHERE question_id = (?)
    # GROUP BY question_id

    
  end
  
  def authored_questions
    Question.find_by_author_id(id)
  end
  
  def authored_replies
    Replies.find_by_user_id(id)    
  end
  
  def create
    raise 'already saved!' unless self.id.nil?
    
    
    params = [self.fname, self.lname]
    QuoraDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    
    SQL
    @id = QuoraDatabase.instance.last_insert_row_id
  end
  
  def followed_questions
    QuestionFollower.followed_question_for_user_id(id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(id0)
  end
  
end
