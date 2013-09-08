require 'action_view'
include ActionView::Helpers::DateHelper

module LinksHelper
	def self.to_relative_date date 

		from_time = Time.now

		distance_of_time_in_words(from_time, date) 
	end
			
	def self.remove_old
		Link.where(:done => true).destroy_all
	end	
end
