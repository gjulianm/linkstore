require "#{Rails.root}/lib/bookmarklet.rb"

class BookmarkletController < ApplicationController
	include BookmarkletHelper
	def index
		@bookmarklet = build_bookmarklet
	end
end
