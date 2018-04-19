class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :edit, :update, :destroy]
  skip_before_action :user_needs_business

  # GET /businesses
  # GET /businesses.json
  # def index
  #   @businesses = Business.all
  # end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
    redirect_to my_business_path if @current_user.business == @business
    raise
    click = Click.where(clicker: current_user, clicked: @business).first
    click.count += 1
    click.save
  end

  # GET /businesses/new
  def new
    @business = Business.new
  end

  # GET /businesses/1/edit
  def edit
  end

  # POST /businesses
  # POST /businesses.json
  def create
    create_hash = create_params
    create_hash["industries"] = create_hash["industries"].split(', ')
    create_hash["employees"] = Business.employees.invert[create_hash["employees"]]
    # raise
    @business = Business.new(create_hash)
    @business.users << current_user
    @business.add_domain
    # raise
    respond_to do |format|
      if @business.save
        update_business(@business, update_params)
        # raise
        format.html { redirect_to suggestions_path, notice: 'Business was successfully created.' }
        format.json { render :show, status: :created, location: @business }
      else
        format.html { render :new }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html { redirect_to @business, notice: 'Business was successfully updated.' }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.html { redirect_to businesses_url, notice: 'Business was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def my_business
    @business = current_user.business
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edit_business_params
      params.require(:business).permit(:name, :industries, :employees, :other_partners, :other_competitors, :desired_partnership_types, :offered_partnership_types, :url, :description, :title, :body, :photo)
    end

    def business_params
      params.permit(:name, :tagline, :url, :photo, :photo_cache, :industries, :employees, :acq_partners, :des_partners, :other_partners, :other_competitors, :desired_partnership_types, :offered_partnership_types, :customer_interests)
    end

    def update_params
      params.permit(:other_competitors, :acq_partners, :des_partners, :customer_interests)
    end

    def create_params
      params.permit(:name, :tagline, :url, :photo, :photo_cache, :industries, :youtube_url, :employees, desired_partnership_types: [], offered_partnership_types: [])
    end

    def update_business(current_business, base_hash)
      current_business.other_partners = []
      current_business.other_competitors = []

      # acquired partnerships
      acquired_partnerships = base_hash["acq_partners"].split(', ')

      acquired_partnerships.each do |acq|
        if Business.where("lower(name) LIKE ?", "#{acq}".downcase).first
          current_business.partnerships.acquired.create!(partner: Business.where("lower(name) LIKE ?", "#{acq}".downcase).first)
        else
          current_business.other_partners << acq
          current_business.save!
        end
      end

      # desired partnerships
      desired_partnerships = base_hash["des_partners"].split(', ')

      desired_partnerships.each do |des|
        if Business.where("lower(name) LIKE ?", "#{des}".downcase).first
          current_business.partnerships.desired.create!(partner: Business.where("lower(name) LIKE ?", "#{des}".downcase).first)
        else
          current_business.other_partners << des
          current_business.save!
        end
      end

      # competitors
      competitors = base_hash["other_competitors"].split(', ')

      competitors.each do |competitor|
        if Business.where("lower(name) LIKE ?", "#{competitor}".downcase).first
          current_business.competitions.create!(competitor: Business.where("lower(name) LIKE ?", "#{competitor}".downcase).first)
        else
          current_business.other_competitors << competitor
        end
      end

      # interests
      interests = base_hash["customer_interests"].split(', ')

      interests.each do |interest|
        current_business.business_customer_interests.create!(
          customer_interest: CustomerInterest.where(name: interest).first_or_create
        )
      end

      # raise
      # save updates
      current_business.save!
    end
end
