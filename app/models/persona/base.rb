class Persona::Base < ActiveRecord::Base
  set_table_name 'personas'
  belongs_to :user
end
