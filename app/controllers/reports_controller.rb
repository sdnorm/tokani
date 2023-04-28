class ReportsController < ApplicationController
  include CurrentHelper

  before_action :set_report, only: [:generate_csv, :generate_pdf]

  def index
  end

  def financial
    @report = Report.new(report_type: "financial")
    setup_form_vars
  end

  def fill_rate
    @report = Report.new(report_type: "fill_rate")

    @customers = current_account.customers.order("name ASC")
    @interpreters = current_account.account_interpreters
    @languages = current_account.languages.order("name ASC")
  end

  def create
    @report = Report.new(report_params)
    @report.account_id = current_account.id

    if @report.save
      if params[:commit]&.downcase&.include?("pdf")
        redirect_to generate_pdf_report_path(@report)
      else
        redirect_to generate_csv_report_path(@report)
      end
    end
  end

  def generate_csv
    csv_string = @report.to_csv
    send_data csv_string, type: "text/csv", disposition: "attachment; filename='#{@report.report_type.titleize} Report.csv'"
  end

  def generate_pdf
    @appointments = @report.fetch_appointments
    html = render_to_string("reports/report", layout: false)
    pdf = WickedPdf.new.pdf_from_string(html, {orientation: "Landscape"})
    send_data pdf, filename: "#{@report.report_type.titleize} Report.pdf", type: "application/pdf"
  end

  private

  def report_params
    params.require(:report).permit(:date_begin, :date_end, :report_type, :in_person, :phone, :video, :interpreter_type, :language_id,
      :customer_category_id, :site_id, :department_id,
      # Fill Rate Report Specific:
      :customer_id, :interpreter_id,
      customer_ids: [], site_ids: [], show_fields: [], fields_to_show: [])
  end

  def set_report
    @report = current_account.reports.find(params[:id])
  end

  def setup_form_vars
    @customer_categories = current_account.customer_categories.active.alphabetical
    @customers = current_account.customers.order("name ASC")
    @languages = current_account.languages.order("name ASC")
  end
end
