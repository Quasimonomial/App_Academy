require_relative 'quoradb.rb'

class Reply
  def self.all
    results = QuoraDatabase.instance.execute('SELECT * FROM replies')
    results.map { |result| Reply.new(result) }
  end
  
  def self.find_by_id reply_id
    results = QuoraDatabase.instance.execute(<<-SQL, reply_id)
    SELECT *
    FROM replies
    WHERE reply_id = ?
    
    SQL
    
    Reply.new(results[0])
  end
  
  attr_accessor :reply_id, :question_id, :parent_id, :body, :author_id
  
  def initialize(reply_hash = {})
    @reply_id = reply_hash['reply_id']
    @question_id = reply_hash['question_id']
    @parent_id = reply_hash['parent_id']
    @body = reply_hash['body']
    @author_id = reply_hash['author_id']
  end
  
  def create
    raise 'already saved!' unless self.reply_id.nil?
    
    params = [self.question_id, self.parent_id, self.body, self.author_id]
    QuoraDatabase.instance.execute(<<-SQL, *params)
    INSERT INTO
      replies (question_id, parent_id, body, author_id)
    VALUES
      (?, ?, ?, ?)
      
    SQL
    @reply_id = QuoraDatabase.instance.last_insert_row_id
  end
  
end

reply = Reply.new({'question_id' => 1, 'parent_id' => nil, 'body' => 'yep lloks like it werx', 'author_id' => '1'})
  

p Reply.all
p Reply.find_by_id(1)
      
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
    