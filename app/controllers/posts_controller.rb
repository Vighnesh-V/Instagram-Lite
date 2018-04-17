class PostsController < ApplicationController
  before_action :set_post, only: [:show, :new, :edit, :update, :destroy, :toggle_like_feed, :toggle_like_post, :new_comment_feed, :new_comment_post]

  def new_comment_feed
    @comment = @post.comments.new(user: current_user, message: comment_params[:message])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to root_path(anchor: "post_#{@post.id}"), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def new_comment_post
    @comment = @post.comments.new(user: current_user, message: comment_params[:message])
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @post, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  def toggle_like_feed
    @post.toggle_like(current_user)
    redirect_to root_path(anchor: "post_#{@post.id}")
  end

  def toggle_like_post
    @post.toggle_like(current_user)
    redirect_to post_path(@post)
  end

 
  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.new(post_params)
    @top_comment = @post.comments.new(user: current_user, message: post_params[:caption])
    respond_to do |format|
      if @post.save  && @top_comment.save
        format.html { redirect_to root_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:message)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:caption, :image)
    end
end
