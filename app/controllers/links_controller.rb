class LinksController < ApplicationController
	def log what
		STDOUT.puts what
	end

	def new
	end

	def create
		newLink = Link.new
		newLink.url = params[:link][:url]
		newLink.done = false
		newLink.title = get_title newLink.url # This needs to run on the background.
		newLink.domain = extract_domain newLink.url
		newLink.save
		redirect_to link_list_path
	end

	def list
		links = Link.all.sort_by { |l| l.created_at } .reverse
		@empty = links.empty?

		pending = links.select { |l| l.editor.nil? && !l.done }
		working = links.select { |l| !l.editor.nil? && !l.done}
		done = links.select { |l| l.done}
		@link_groups = {
			"Pending" => pending,
			"Working on it" => working,
			"Done" => done
		}
	end

	def create_get
		newLink = Link.new
		newLink.url = params[:url]
		newLink.done = false
		newLink.title = get_title newLink.url # This needs to run on the background.
		newLink.domain = extract_domain newLink.url
		newLink.save
		redirect_to link_list_path
	end

	def set_editor
		link = Link.find_by("id = " + params[:id])

		if link
			log 'exists!'
			link.editor = session[:user]
			link.save
		end
	end

	def release
		link = Link.find_by("id = " + params[:id])

		if link
			link.editor = nil
			link.save
		end
	end

	def done
		link = Link.find_by("id = " + params[:id])

		if link
			link.done = true
			link.save
		end
	end

	def bookmarklet 
		host = '127.0.0.1:3000'
		# host = 'gblinkslinks.herokuapp.com'
		@bookmarklet = get_bookmarklet 'bookmarklet.js', { :host => host}
	end

	def get_bookmarklet(file, hash)
	    # read the javascript file
	    js = File.open( "#{Rails.root}/app/assets/javascripts/#{file}", 'r' ).read
	    # Tabs to spaces
	    js.gsub!( /s{\t}{ }gm/, '' )
	    # Space runs to one space
	    js.gsub!( /s{ +}{ }gm/, '' )         
	    # Kill line-leading whitespace
	    js.gsub!( /s{^\s+}{}gm/, '' )        
	    # Kill line-ending whitespace
	    js.gsub!( /s{\s+$}{}gm/, '' )
	    # Kill newlines
	    js.gsub!( /s{\n}{}gm/, '' )

	    hash.each_pair do |k,v|
	    	js.gsub!( "{{#{k.to_s}}}", v )
	    end

	    "javascript:(function(){#{js}}());"
	end

	def extract_domain url
		domain_regex = 'https?://([^/]*)/?'
		match = url.match domain_regex
		if match
			return match[1]
		else
			return url
		end
	end

	def extract_title body
		title_regex = '<title>(.*)</title>'
		match = body.match title_regex
		if match
			return match[1]
		else
			return ' - Title unknown - '
		end
	end

	def get_title url
		begin
			log 'Trying to get title for ' + url
			resp = RestClient.get url

			if resp.code == 200
				return extract_title resp.body
			else
				return ' - Title unknown - '
			end
		rescue RuntimeError => e
			log e.inspect
			return ' - Title unknown - '
		end
	end
end
