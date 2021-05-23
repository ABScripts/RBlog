class PostsController < ApplicationController
    before_action :authenticate_user!, only: %i[new create edit update delete]
    before_action :find_post, only: %i[edit update show delete]
    before_action :correct_post, only: %i[:edit, :update, :destroy]

    def index
        @posts = Post.ordered.with_authors
    end

    def show
    end

    def new
        @post = current_user.posts.build
    end

    def create
        @post = current_user.posts.build(post_params)

        @post.author = current_user

        if @post.save
          redirect_to @post
        else
          render :new 
        end
    end

    def edit
    end

    def update
        if @post.update(post_params)
            redirect_to @post
        else
            render :edit
        end
    end

    def delete
        if @post.destroy
            redirect_to posts_path
        else
            redirect_to posts_path, error: "Error while deleting post occured!"
        end
    end

    private

    def post_params
        params.require(:post).permit(:title, :body)
    end

    def find_post
        @post = Post.find(params[:id])
    end

    def correct_post
        @owned_post = current_user.posts.find_by(id: params[:id])
        unless owned_post
            redirect_to posts_path, notice: "Fails link access!"
        end
    end
end
