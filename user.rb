require_relative 'quoradb.rb'

class User
  def self.all
    results = QuoraDatabase.instance.execute('SELECT * FROM users')
    results.map { |result| User.new(result) }
  end
    
  attr_accessor :id, :fname, :lname
  
  def initialize(user_hash = {})
    @id = user_hash['id']
    @fname = user_hash['fname']
    @lname = user_hash['lname']
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
  
end

bob = User.new({'fname' => 'bob', 'lname' => 'the slob'})
bob.create
bob.create
p User.all