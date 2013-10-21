class HipchatController < ApplicationController
 	http_basic_authenticate_with name: ENV['LS_USER'], password: ENV['LS_PASSWORD']

	def configure
		@token = Settings.HC_Token
		@room = Settings.HC_Room
	end

	def config_save
		Settings.HC_Token = params[:hipchat][:token]
		Settings.HC_Room = params[:hipchat][:room]

		flash[:message] = 'Parameters saved!'

		redirect_to hipchat_config_path
	end
end
