class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def import
    @project = Project
    @import = Mudhead::Importer.new(@project, nil, {})
  end

  def do_import
    @project = Project
    # @import = Mudhead::Importer.new(@project, params[:file], { before_batch_import: -> (importer) {
    #   puts '*************************'
    #   project_names = importer.chunk.map { |x| x[:name] }
    #   projects = Project.where(name: project_names).pluck(:name, :id)
    #   options = Hash[*projects.flatten]
    #   importer.batch_replace(:name, options)
    # }})
    @import = Mudhead::Importer.new(@project, params[:file], {})
    @import.import
    if @import.import_result.failed?
      render :import
    else
      redirect_to projects_path, notice: 'Project was successfully created.'
    end
  end

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/1
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :active)
    end
end
