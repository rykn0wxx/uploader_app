class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def import
    @client = Client
    @import = Mudhead::Importer.new(@client, nil, {})
  end

  def do_import
    @client = Client
    @import = Mudhead::Importer.new(@client, params[:file], { before_batch_import: -> (importer) {
      project_names = importer.chunk.map { |x| x[:project_id] }
      projects = Project.where(name: project_names).pluck(:name, :id)
      options = Hash[*projects.flatten]
      importer.batch_replace(:project_id, options)
    }})
    @import.import
    if @import.import_result.failed?
      render :import
    else
      redirect_to clients_path, notice: 'Project was successfully created.'
    end
  end

  # GET /clients
  def index
    @clients = Client.includes(:project).all
  end

  # GET /clients/1
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients
  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client, notice: 'Client was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      redirect_to @client, notice: 'Client was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
    redirect_to clients_url, notice: 'Client was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.includes(:project).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def client_params
      params.require(:client).permit(:name, :active, :project_id)
    end
end
