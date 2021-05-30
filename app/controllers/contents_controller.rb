class ContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_content, only: [ :show, :edit, :update, :destroy]
  
  def index
    @contents = current_user.contents

    tag_names = params[:tags]

    if tag_names.present?
      @contents = @contents.joins(:tags).where(tags: {name: tag_names}).distinct
    end
  end

  def new
    @content = Content.new
  end

  def show
    #@content = Content.find(params[:id])
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end

  def create
    @content = current_user.contents.build(content_params)
    
    if @content.save 
      associate_tags!
      redirect_to contents_path, notice: 'Content successfully created'
    else     
      render :new
    end
  end

  def edit
    #@content = Content.find(params[:id])
  end

  def update
    #@content = Content.find(params[:id])
    if @content.update(content_params)
      associate_tags!
      redirect_to contents_path, notice: 'Content successfully updated'
    else     
      render :edit
    end
  end

  def destroy
    #@content = Content.find(params[:id])
    @content.destroy

    redirect_to contents_path, notice: "Content successfully deleted id: #{@content.id}"
  end

  private

  def set_content
    @content = Content.find(params[:id])
  end

  def tags_params
    params.require(:content).permit(tags: [])[:tags].reject(&:blank?)
  end

  def content_params
    params.require(:content).permit( :title, :description)
  end

  def associate_tags!
    tags = tags_params.map do |tag_name|
      current_user.tags.where(name: tag_name).first_or_initialize
    end

    @content.tags = tags
  end
end
