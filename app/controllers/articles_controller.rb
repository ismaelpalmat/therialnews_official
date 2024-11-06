class ArticlesController < ApplicationController
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]
  before_action :authorize_admin!, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @articles = Article.all
  end

  def show
    @comments = @article.comments.includes(:user) # Cambié @Comments a @comments
    @comment = Comment.new # Inicializa el comentario para el formulario
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      flash[:notice] = "Articulo editado de manera exitosa"
      redirect_to @article
    else
      flash[:alert] = "Error editando el articulo"
      render :edit
    end
  end

  def destroy
    @article.destroy
    flash[:notice] = "Article was successfully deleted."
    redirect_to articles_path
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def authorize_admin!
    unless current_user&.admin?
      flash[:alert] = "No estás autorizado para realizar esta acción"
      redirect_to root_path
    end
  end

  def article_params
    params.require(:article).permit(:title, :content)
  end
end
