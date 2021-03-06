require_dependency "blogelator/admin/application_controller"

module Blogelator
  module Admin
    class PostsController < ApplicationController
      before_action :authorize_user
      before_action :set_post, only: [:show, :edit, :update, :destroy]
      respond_to :json
      respond_to :html, only: [:index]
      
      # POST /api/posts
      def create
        @post = Blogelator::Post.new(post_params)
        @post.author = blogelator_current_user
        
        if @post.save
          render json: @post, status: :created
        else
          render json: @post, status: :unprocessable_entity
        end
      end
      
      # DELETE /api/posts/1
      def destroy
        @post.destroy
        head :no_content
      end

      # GET /api/posts
      def index
        @posts = Blogelator::Post.unpublished + Blogelator::Post.published
        respond_with @posts
      end

      # GET /api/posts/1
      def show
        @title = @post.title
        render json: @post
      end
      
      # PATCH/PUT /api/posts/1
      def update
        if @post.update(post_params)
          render json: @post
        else
          render json: @post, status: :unprocessable_entity
        end
      end

    private
    
      def authorize_user
        authorize! :manage, Blogelator::Post
      end
      
      # Use callbacks to share common setup or constraints between actions.
      def set_post
        @post = Blogelator::Post.find(params[:id])
      end
      
      # Only allow a trusted parameter "white list" through.
      def post_params
        params.require(:post).permit(:body_markdown, :custom_summary, :published_at, :title)
      end
    end
  end
end
