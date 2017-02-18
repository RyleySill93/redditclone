class PostsController < ApplicationController

  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_user_match, only: [:edit, :update, :destroy]
  def new
    @post = Post.new
    render :new
  end

  def create
    # @subs = Sub.all
    @post_params = post_params
    subs = @post_params.delete(:sub_ids).map(&:to_i)
    @post = Post.new(@post_params)
    @post.author_id = current_user.id
    if @post.save
      subs.each do |sub_id|
        PostSub.create!(sub_id: sub_id, post_id: @post.id)
      end
      redirect_to post_url(@post)
    else

      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post_params = post_params
    subs = @post_params.delete(:sub_ids).map(&:to_i)
    if @post.update(@post_params)
      PostSub.where(post_id: @post.id).destroy_all
      subs.each do |sub_id|
        PostSub.create!(sub_id: sub_id, post_id: @post.id)
      end
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    sub_id = @post.sub_id
    @post.delete
    redirect_to sub_url(sub_id)
  end

  def show
    @post = Post.find(params[:id])
  end

  def require_user_match
    @post = Post.find(params[:id])
    redirect_to post_url(@post) unless @post.author_id == current_user.id
  end

  private
  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end
end
