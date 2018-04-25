# Comment Controller
class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet.
  def comment_params
    params.require(:comment)
          .permit(:user_id, :post_id, :message)
  end
end
