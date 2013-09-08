class Comment < ActiveRecord::Base
  belongs_to :link, :class_name => "Link"
end
