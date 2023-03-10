class RecipientsController < ApplicationController
  include CurrentHelper
  before_action :set_recipient, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /recipients
  def index
    @pagy, @recipients = pagy(Recipient.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @recipients
  end

  # GET /recipients/1 or /recipients/1.json
  def show
  end

  # GET /recipients/new
  def new
    @recipient = Recipient.new
    grab_account_customers_when_needed
    # Uncomment to authorize with Pundit
    # authorize @recipient
  end

  # GET /recipients/1/edit
  def edit
    grab_account_customers_when_needed
  end

  # POST /recipients or /recipients.json
  def create
    @recipient = Recipient.new(recipient_params)
    grab_account_customers_when_needed

    # Uncomment to authorize with Pundit
    # authorize @recipient

    respond_to do |format|
      if @recipient.save
        format.html { redirect_to @recipient, notice: "Recipient was successfully created." }
        format.json { render :show, status: :created, location: @recipient }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipients/1 or /recipients/1.json
  def update
    respond_to do |format|
      if @recipient.update(recipient_params)
        format.html { redirect_to @recipient, notice: "Recipient was successfully updated." }
        format.json { render :show, status: :ok, location: @recipient }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipients/1 or /recipients/1.json
  def destroy
    @recipient.destroy
    respond_to do |format|
      format.html { redirect_to recipients_url, status: :see_other, notice: "Recipient was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipient
    @recipient = Recipient.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @recipient
  rescue ActiveRecord::RecordNotFound
    redirect_to recipients_path
  end

  # Only allow a list of trusted parameters through.
  def recipient_params
    params.require(:recipient).permit(:last_name, :first_name, :email, :srn, :primary_phone, :mobile_phone, :allow_text, :allow_email, :customer_id)

    # Uncomment to use Pundit permitted attributes
    # params.require(:recipient).permit(policy(@recipient).permitted_attributes)
  end

  def grab_account_customers_when_needed
    if customer_logged_in?
      @recipient.customer_id = current_account.id if action_name == "create"
    elsif action_name == "create"
      @recipient.customer_id = current_account.id
    end
  end
end
