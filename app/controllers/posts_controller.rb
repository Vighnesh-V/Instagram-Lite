# Posts Controller
class PostsController < ApplicationController
  before_action :set_post, except: %I[index create]

  def new_comment_feed
    ps = comment_params[:message]
    @comment = @post.comments.new(user: current_user, message: ps)
    if @comment.save
      redirect_to root_path(anchor: "post_#{@post.id}")
    else
      render :new
    end
  end

  def new_comment_user
    ps = comment_params[:message]
    @comment = @post.comments.new(user: current_user, message: ps)
    if @comment.save
      redirect_to "/users/#{@post.user.id}"
    else
      render :new
    end
  end

  def new_comment_post
    ps = comment_params[:message]
    @comment = @post.comments
                    .new(user: current_user, message: ps)
    if @comment.save
      redirect_to @post
    else
      render :new
    end
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  def toggle_like_feed
    @post.toggle_like(current_user)
    redirect_to root_path(anchor: "post_#{@post.id}")
  end

  def toggle_like_user
    @post.toggle_like(current_user)
    redirect_to "/users/#{@post.user.id}"
  end

  def toggle_like_post
    @post.toggle_like(current_user)
    redirect_to post_path(@post)
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.new(post_params)
    @top_comment = @post.comments
                        .new(user: current_user, message: post_params[:caption])
    if @post.save && @top_comment.save
      redirect_to root_path
    else
      render :new
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    redirect_to root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:message)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet.
  def post_params
    params.require(:post).permit(:caption, :image)
  end
end
