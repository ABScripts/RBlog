require_relative "../../lib/services/pagination.rb"

class PostsController < ApplicationController
    before_action :authenticate_user!, only: %i[new create edit update delete]
    before_action :find_post, only: %i[edit update show delete]
    before_action :correct_post, only: %i[:edit, :update, :destroy]

    def index
        
        page_token = params.has_key?(:older) ? params[:older] : params[:newer]
        
        paginate(page_token)

        if (query = params[:query])
            @posts =  @posts.where('title LIKE ?', "#{params[:query].squish}%")
        end
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

    def paginate(page_token, topic_id = nil)
        pagination = Services::Pagination.new(page_token, topic_id)
    
        if page_token.present?
          if params.has_key?(:newer)
            @posts = pagination.newer
          else 
            @posts = pagination.older
          end  
        else 
          @posts = pagination.first_page
        end
    
        @has_newer = pagination.has_newer
        @has_older = pagination.has_older
    
        @page_token = pagination.construct_page_token
      end
end
