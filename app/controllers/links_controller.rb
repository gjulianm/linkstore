require "#{Rails.root}/lib/hipchat.rb"

class LinksController < ApplicationController
	include HipChatHelper

	def send_create_notification link
		log 'Sending notification (send) to HipChat...'
		claim_path = "#{request.protocol}#{request.host}:#{request.port}#{link_claim_path(link.id)}"
		message = "#{link.poster} ha enviado un enlace: <a href=\"#{link.url}\">#{link.title}</a>. <a href=\"#{claim_path}\">Clic para asignarme el enlace.</a>"

		begin
			send_hc_message message
			log 'HC notification sent.'
		rescue => e
			flash[:error] = 'Could not send HipChat message.'
			log 'Error sending notification.'
			log e.inspect
		end
	end

	def send_claim_notification link
		log 'Sending notification (claim) to HipChat...'
		message = "Enlace <a href=\"#{link.url}\">#{link.title}</a> asignado a <b>#{link.editor}</b>."
	
		begin
			send_hc_message message
			log 'HC notification sent.'
		rescue => e
			flash[:error] = 'Could not send HipChat message.'
			log 'Error sending notification.'
			log e.inspect
		end
	end

	def log what
		STDOUT.puts what
	end

	def new
	end

	def create
		create_link params[:link][:url], session[:user]
	end

	def nourl_create 
		newLink = Link.new
		newLink.url = nil
		newLink.done = false
		newLink.title = params[:task][:title]
		newLink.domain = 'task'
		newLink.poster = session[:user] || 'anonymous'
		newLink.save
		send_create_notification newLink
		redirect_to link_list_path
	end

	def create_link url, user
		newLink = Link.new
		newLink.url = url
		newLink.done = false
		newLink.title = get_title newLink.url # This needs to run on the background.
		newLink.domain = extract_domain newLink.url
		newLink.poster = user || 'anonymous'
		newLink.save
		send_create_notification newLink
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
	
	def rss
		links = Link.all.sort_by { |l| l.created_at } .reverse
		@empty = links.empty?

		pending = links.select { |l| l.editor.nil? && !l.done }
		#working = links.select { |l| !l.editor.nil? && !l.done}
		#done = links.select { |l| l.done}
		@link_groups = {
			"Pending" => pending
		}
	  render layout: false
	end
	
	def rssauthor
		links = Link.all.sort_by { |l| l.created_at } .reverse
		@empty = links.empty?

		#pending = links.select { |l| l.editor.nil? && !l.done }
		working = links.select { |l| !l.editor.nil? && l.editor == params[:id] && !l.done}
		#done = links.select { |l| l.done}
		@link_groups = {
			"Working" => working
		}
	  render layout: false
	end

	def create_get
		create_link params[:url], params[:user]
	end

	def set_editor
		link = Link.find_by("id = " + params[:id])

		if link
			link.editor = session[:user]
			link.save
		else
			log 'Could not find link #{params[:id]}'
		end

		send_claim_notification link
		@link = link
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
		@bookmarklet = get_bookmarklet 'auxiliar/bookmarklet.js', { :host => host}
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

	    js = URI.escape(js)
	    return "javascript:(function(){#{js}}());"
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
		body = body.encode!('UTF-8', 'UTF-8', :invalid => :replace) 
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
		rescue => e
			log e.inspect
			return ' - Title unknown - '
		end
	end
end
