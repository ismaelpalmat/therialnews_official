class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!, only: [ :destroy ]
  before_action :set_article
  before_action :set_comment, only: [ :destroy ]


  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Comentario agregado!"
      redirect_to @article
    else
      flash[:alert] = "Error al agregar el comentario"
      render "articles/show"
    end
  end


  def destroy
    @comment = @article.comments.find(params[:id])

    if @comment.user == current_user
      @comment.destroy
      flash[:notice] = "Comentario eliminado!"
    else
      flash[:alert] = "No estas autorizado para borrar este comentario"
    end
    redirect_to @article
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def authorize_user!
    unless @comment.user == current_user
      flash[:alert] = "No estas autorizado"
      redirect_to @article
    end
  end
end
