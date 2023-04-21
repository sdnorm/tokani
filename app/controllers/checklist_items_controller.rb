class ChecklistItemsController < ApplicationController
  include CurrentHelper

  before_action :set_checklist_item, only: [:update, :destroy]
  before_action :verify_authorized_item, only: [:update, :destroy]

  def new
    @interpreter = current_account.interpreters.find(params[:interpreter_id])
    @avail_checklist_types = @interpreter.available_checklist_types(current_account)
    @checklist_item = @interpreter.checklist_items.build
  end

  def edit
    @checklist_item = ChecklistItem.find(params[:id])
    @interpreter = @checklist_item.user
    verify_authorized(@interpreter)
    @avail_checklist_types = @interpreter.available_checklist_types(current_account)
  end

  def interpreter_items
    @interpreter = current_account.interpreters.find(params[:id])
    verify_authorized(@interpreter)

    @checklist_items = @interpreter.checklist_items.includes(:checklist_type).with_attached_document.order("checklist_types.name ASC")
    @avail_checklist_types = @interpreter.available_checklist_types(current_account)
    @new_checklist_item = @interpreter.checklist_items.build
  end

  def update
    @checklist_item = ChecklistItem.find(params[:id])
    @interpreter = @checklist_item.user
    if !@checklist_item.user.account_users.map(&:account).include?(current_account)
      # Permission denied
      return redirect_to "/"
    end

    update_fields = checklist_item_params if params[:checklist_item].present?

    if params[:exp_date_toggle].blank? || params[:exp_date_toggle] == "false"
      update_fields ||= {}
      update_fields[:exp_date] = nil
    end

    if update_fields.nil?
      render status: :unprocessable_entity
      return
    end

    if @checklist_item.update(update_fields)
      redirect_to interpreter_items_checklist_item_path(@interpreter), notice: "#{@checklist_item.name} updated"
    else
      redirect_to interpreter_items_checklist_item_path(@interpreter), alert: "Error: #{@checklist_item.errors.full_messages.join("; ")}"
    end
  end

  def create
    @checklist_item = ChecklistItem.new(checklist_item_params)
    @interpreter = User.find(@checklist_item.user_id)

    verify_authorized(@interpreter)

    if @checklist_item.save
      redirect_to interpreter_items_checklist_item_path(@interpreter), notice: "#{@checklist_item.name} Created!"
    else
      render turbo_stream: turbo_stream.update("new_checklist_item_notice", partial: "shared/error_messages", locals: {resource: @checklist_item})
    end
  end

  def destroy
    @checklist_item.destroy
    redirect_to interpreter_items_checklist_item_path(@checklist_item.user_id), notice: "Checklist item removed."
  end

  private

  def set_checklist_item
    @checklist_item = ChecklistItem.find(params[:id])
  end

  def verify_authorized_item
    if current_user.is_agency_admin?
      if !@checklist_item.user.account_users.map(&:account).include?(current_account)
        raise Pundit::NotAuthorizedError # Permission denied
      end
    elsif current_user.is_interpreter?
      if @checklist_item.user != current_user
        raise Pundit::NotAuthorizedError # Permission denied
      end
    end
  end

  def verify_authorized(interpreter)
    if current_user.is_agency_admin?
      if !interpreter.account_users.map(&:account).include?(current_account)
        raise Pundit::NotAuthorizedError # Permission denied
      end
    elsif current_user.is_interpreter?
      if interpreter != current_user
        raise Pundit::NotAuthorizedError # Permission denied
      end
    end
  end

  def checklist_item_params
    params.require(:checklist_item).permit(:exp_date, :document, :user_id, :checklist_type_id, :id)
  end
end
