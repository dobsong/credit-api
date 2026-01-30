class ReadingListsController < ApplicationController
  before_action :set_reading_list, only: %i[ destroy ]

  # GET /reading_lists
  def index
    username = current_user["preferred_username"]
    @reading_lists = ReadingList.where(user: username).includes(:bibliography_reference)
    # This is a bit non-standard, but we want to merge in the bibliography reference fields in the response even though there are two models
    # This is an attempt to minimise storage redundancy whilst only exposing the meaningful part to the client
    render json: @reading_lists.map { |rl| rl.bibliography_reference.as_json.merge(id: rl.id, created_at: rl.created_at, updated_at: rl.updated_at) }
  end

  # POST /reading_lists
  def create
    username = current_user["preferred_username"]

    # Find or create the bibliography entry
    bibliography_reference = BibliographyReference.find_or_create_by(citation: reading_list_params[:citation]) do |b|
      b.title = reading_list_params[:title]
      b.authors = reading_list_params[:authors]
      b.year = reading_list_params[:year]
      b.url = reading_list_params[:url]
    end

    # Create the reading list entry
    @reading_list = ReadingList.new(user: username, bibliography_reference: bibliography_reference)

    if @reading_list.save
      render json: @reading_list, status: :created, location: @reading_list
    else
      render json: @reading_list.errors, status: :unprocessable_content
    end
  end

  # DELETE /reading_lists/:id
  def destroy
    @reading_list.destroy!
  end

  private
    def set_reading_list
      @reading_list = ReadingList.find(params[:id])
      username = current_user["preferred_username"]

      unless @reading_list.user == username
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end

    def reading_list_params
      params.require(:reading_list).permit(:title, :authors, :year, :url, :citation)
    end
end
