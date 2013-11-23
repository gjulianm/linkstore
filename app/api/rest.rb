module Linkstore
	class API < Grape::API
		version 'v1', using: :path
		format :json
		default_format :json

		helpers do
			def logger
				API.logger
			end
		end

		resource :links	do
			desc 'Get all the links'
			get do
				Link.all
			end 

			desc 'Create link'
			post :new do
				authenticate!
				newLink = Link.new
				newLink.url = params[:url]
				newLink.done = false
				newLink.title = params[:title] || get_title params[:url]
				newLink.domain = extract_domain params[:url]
				newLink.poster = params[:user]
				newLink.priority = 0
				newLink.save
				send_create_notification
				return newLink
			end

			params do
				requires :id, type: Integer, desc: "Status id."
			end
			route_param :id do
				desc 'Delete link'
				delete do
					Link.find(params[:id]).destroy
				end

				get do
					Link.find(params[:id])
				end

				params do
					requires :user, type: String, desc: "Username"
				end
				post :editor
					link = Link.find(params[:id])
					error! 'Not found', 404 unless link

					link.editor = params[:user]
				end

				post :done
					link = Link.find(params[:id])
					error! 'Not found', 404 unless link

					link.done = true
				end

				params do 
					requires :priority, type: Integer, desc: "Priority"
				end
				post :priority
					link = Link.find(params[:id])
					error! 'Not found', 404 unless link

					link.priority = params[:priority]
				end
			end # route_param :id
		end # resource :link
	end #class 
end #module
