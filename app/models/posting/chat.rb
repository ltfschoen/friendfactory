class Posting::Chat < ActiveRecord::Base
  
  set_table_name :posting_chats
  has_one :base, :class_name => 'Posting::Base', :as => :resource

end