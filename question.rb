class Question
  def self.all
    results = QuoraDatabase.instance.execute('SELECT * FROM questions')
    results.map { |result| Question.new(result) }
  end
    
  def self.find_by_id question_id
    results = QuoraDatabase.instance.execute(<<-SQL, question_id)
    SELECT *
    FROM questions
    WHERE id = (?)
  
    SQL
  
    Question.new(results[0])
  end
    
  def self.find_by_author_id(author_id)
    results = QuoraDatabase.instance.execute(<<-SQL, author_id)
    SELECT *
    FROM question
    WHERE author_id = (?)
    
    SQL
    results.map { |result| Question.new(result) }
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
  
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
  
  attr_accessor :id, :title, :body, :author_id
  
  def initialize(question_hash = {})
    @id = question_hash['id']
    @title = question_hash['title']
    @body = question_hash['body']
    @author_id = question_hash['author_id']
  end
  
  def author
    User.find_by_id(author_id)
  end
  
  def create
    raise 'already saved!' unless self.id.nil?
    
    
    params = [self.title, self.body, self.author_id]
    QuoraDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO
        questions (title, body, author_id)
      VALUES
        (?, ?, ?)
    
    SQL
    @id = QuoraDatabase.instance.last_insert_row_id
  end
  
  def followers
    QuestionFollower.followers_for_question_id(id)
  end
  
  def likers
    QuestionLike.likers_for_question_id(id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(id)
  end
  
  def replies
    Reply.find_by_question_id(id)
  end
  
    
end
