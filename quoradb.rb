require 'singleton'
require 'sqlite3'

class QuoraDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('quora.db')  # doesn't exist yet
  
    self.results_as_hash = true
    
    self.type_translation = true
  end
end