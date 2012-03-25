require 'active_record/acts/commentable'

ActiveRecord::Base.send :include, ActiveRecord::Acts::Commentable
