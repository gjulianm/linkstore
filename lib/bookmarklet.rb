module BookmarkletHelper
	def read_bookmarklet(file, hash)
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

		js = URI.escape(js)
		return "javascript:(function(){#{js}}());"
	end

	def build_bookmarklet
		host = "#{request.protocol}#{request.host}:#{request.port}"
		vars = { 
			:host => host,
			:user => session[:user]
		}
		return read_bookmarklet 'auxiliar/bookmarklet.js', vars
	end
end