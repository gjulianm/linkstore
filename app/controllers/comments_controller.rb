class CommentsController < ApplicationController
  def create
  	newComment = Comment.new
  	newComment.text = params[:comment][:text]
  	newComment.link_id = params[:id]
  	newComment.author = session[:user]
  	newComment.save
  	redirect_to link_list_path
  end
end
