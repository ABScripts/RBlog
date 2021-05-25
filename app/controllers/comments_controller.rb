class CommentsController < ApplicationController
    before_action :find_post, only: %i[create destroy]

      def create
        @comment = @post.comments.create(:commenter => current_user.email, :body => comment_params[:body])
        redirect_to post_path(@post)
      end

      def destroy
        @comment = @post.comments.find(params[:id])
        @comment.destroy
        redirect_to post_path(@post)
      end

    private
      def comment_params
        params.require(:comment).permit(:body)
      end

      def find_post
        @post = Post.find(params[:post_id])
      end
end
