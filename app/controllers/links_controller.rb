require "#{Rails.root}/lib/hipchat.rb"
require "#{Rails.root}/lib/bookmarklet.rb"

class LinksController < ApplicationController
	include HipChatHelper
	include BookmarkletHelper

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
		create_link params[:link][:url], session[:user], nil
	end

	def nourl_create 
		newLink = Link.new
		newLink.url = nil
		newLink.done = false
		newLink.title = params[:task][:title]
		newLink.domain = 'task'
		newLink.poster = session[:user] || 'anonymous'
		newLink.priority = 0
		newLink.save
		send_create_notification newLink
		redirect_to link_list_path
	end

	def create_link url, user, title
		existing = Link.find(:first,  :conditions => [ "url = ?", url])

		if existing
			flash[:error] = "Duplicated link"
		else
			newLink = Link.new
			newLink.url = url
			newLink.done = false
			if !title.nil?
				newLink.title = title
			else
				newLink.title = LinksHelper.get_title newLink.url # This needs to run on the background.
			end
			newLink.domain = LinksHelper.extract_domain newLink.url
			newLink.poster = user || 'anonymous'
			newLink.save
			send_create_notification newLink
		end
		
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

		@bookmarklet = build_bookmarklet
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
		create_link params[:url], params[:user], params[:title]
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

	def remove
		link = Link.find_by("id = " + params[:id])

		if link
			link.destroy
			render :nothing => true, :status => 200
		else
			render :nothing => true, :status => 404
		end
	end

	def bookmarklet 
		@bookmarklet = build_bookmarklet
	end	
end
