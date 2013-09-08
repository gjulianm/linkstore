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

	def self.search_done_links feed
		begin
			links = Link.all
			res = RestClient.get feed

			if res.code == 200
				body = res.body
				links.each do |l|
					if body.index l.url
						l.done = true
						l.save
					end
				end
			end
		rescue
		end
	end
end
