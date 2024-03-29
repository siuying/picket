class SitesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_site, :except => [:index, :new, :create]
  before_filter :required_owner!, :except => [:index, :new, :create]

  # GET /sites
  # GET /sites.json
  def index
    @sites = current_user.sites

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.json
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @site }
    end
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites
  # POST /sites.json
  def create
    @site = Site.new(params[:site])
    @site.user = current_user

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, notice: 'Site was successfully created.' }
        format.json { render json: @site, status: :created, location: @site }
      else
        format.html { render action: "new" }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sites/1
  # PUT /sites/1.json
  def update
    if params[:site][:url] != @site.url
      @site.reset! 
      Resque.enqueue(SiteChecker, @site.id.to_s)
    end

    respond_to do |format|
      if @site.update_attributes(params[:site])
        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site.destroy

    respond_to do |format|
      format.html { redirect_to sites_url }
      format.json { head :no_content }
    end
  end
  
  private
  def load_site
    @site = current_user.sites.find(params[:id])
  end

  def required_owner!
    if @site.user_id != current_user.id
      render :nothing => true, :status => :forbidden
    end
  end

end