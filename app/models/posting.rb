class Posting
  attr_accessor :dao

  def self.each &block
    Posting::Base.find_each &block 
  end

  def initialize dao
    @dao = dao
  end
end
