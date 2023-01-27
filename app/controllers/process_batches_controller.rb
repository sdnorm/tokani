class ProcessBatchesController < ApplicationController
  include CurrentHelper

  before_action :set_process_batch, only: %i[show download_pdf download_csv download_interpreter_csv destroy]

  def index
    @pagy, @process_batches = pagy(current_account.process_batches.latest)
  end

  def new
    @process_batch = ProcessBatch.new
    setup_form_vars
  end

  def create
    @process_batch = ProcessBatch.new(process_batch_params)
    @process_batch.account_id = current_account.id

    respond_to do |format|
      if @process_batch.save
        @process_batch.export!
        format.html { redirect_to process_batch_path(@process_batch), notice: "Process batch created." }
        format.json { render :show, status: :created, location: @process_batch }
      else
        setup_form_vars
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @process_batch.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    setup_appointments
  end

  def download_pdf
    setup_appointments
    html = render_to_string("process_batches/appointments", layout: false)
    pdf = WickedPdf.new.pdf_from_string(html)
    send_data pdf, filename: "process-#{@process_batch.process_id}.pdf", type: "application/pdf"
  end

  def download_csv
    csv_string = @process_batch.to_csv
    send_data csv_string, type: "text/csv", disposition: "attachment; filename=process-#{@process_batch.process_id}.csv"
  end

  def download_interpreter_csv
    csv_string = @process_batch.to_interpreter_csv
    send_data csv_string, type: "text/csv", disposition: "attachment; filename=process-#{@process_batch.process_id}.csv"
  end

  def destroy
    @process_batch.revert_batch!
    @process_batch.destroy
    redirect_to process_batches_path, notice: "Process batch deleted."
  end

  private

  def setup_appointments
    case @process_batch.batch_type
    when "customer"
      @appointments = ProcessBatch.group_appointments_for_display(@process_batch.appointments)
    when "interpreter"
      @appointments = ProcessBatch.group_appointments_for_interpreter_display(@process_batch.appointments)
    end
  end

  def set_process_batch
    @process_batch = ProcessBatch.find(params[:id])
  end

  def setup_form_vars
    @customers = current_account.customers
    @interpreters = current_account.interpreters
  end

  # Only allow a list of trusted parameters through.
  def process_batch_params
    params.require(:process_batch).permit(:start_date, :end_date, :batch_type,
      customer_ids: [], interpreter_ids: [])
  end
end
