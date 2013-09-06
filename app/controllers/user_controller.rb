class UserController < ApplicationController
	def index
		@user = session[:user]
	end

	def set
		session[:user] = params[:username][:name]
		redirect_to link_list_path
	end
end
