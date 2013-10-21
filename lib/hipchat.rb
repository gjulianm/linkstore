module HipChatHelper
	def get_hc_client
		apikey = Settings.HC_Token
		room = Settings.HC_Room

		client = HipChat::Client.new(apikey)
		return client[room]
	end

	def send_hc_message msg
		client = get_hc_client

		client.send('Linkstore', msg)
	end
end