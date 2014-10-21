require_relative 'quoradb.rb'

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
    
  attr_accessor :id, :title, :body, :author_id
  
  def initialize(question_hash = {})
    @id = question_hash['id']
    @title = question_hash['title']
    @body = question_hash['body']
    @author_id = question_hash['author_id']
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
  
end

question = Question.new({'title' => 'DOes this work???', 'body' => 'I need to know.', 'author_id' => 4})
  
question.create
p Question.all
p Question.find_by_id(1)