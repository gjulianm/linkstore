class Link < ActiveRecord::Base
	has_many :comments, :class_name => "Comment"
end
