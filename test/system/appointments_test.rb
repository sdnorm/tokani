require "application_system_test_case"

class AppointmentsTest < ApplicationSystemTestCase
  setup do
    @appointment = appointments(:one)
  end

  test "visiting the index" do
    visit appointments_url
    assert_selector "h1", text: "Appointments"
  end

  test "creating a Appointment" do
    visit appointments_url
    click_on "New Appointment"

    fill_in "Admin notes", with: @appointment.admin_notes
    fill_in "Billing notes", with: @appointment.billing_notes
    fill_in "Cancel reason code", with: @appointment.cancel_reason_code
    fill_in "Canceled by", with: @appointment.canceled_by
    fill_in "Confirmation date", with: @appointment.confirmation_date
    fill_in "Confirmation notes", with: @appointment.confirmation_notes
    fill_in "Confirmation phone", with: @appointment.confirmation_phone
    fill_in "Details", with: @appointment.details
    fill_in "Duration", with: @appointment.duration
    fill_in "Finish time", with: @appointment.finish_time
    fill_in "Gender req", with: @appointment.gender_req
    check "Home health appointment" if @appointment.home_health_appointment
    fill_in "Interpreter type", with: @appointment.interpreter_type
    fill_in "Lock version", with: @appointment.lock_version
    fill_in "Modality", with: @appointment.modality
    fill_in "Notes", with: @appointment.notes
    fill_in "Ref number", with: @appointment.ref_number
    fill_in "Start time", with: @appointment.start_time
    check "Status" if @appointment.status
    fill_in "Sub type", with: @appointment.sub_type
    fill_in "Time zone", with: @appointment.time_zone
    click_on "Create Appointment"

    assert_text "Appointment was successfully created"
    assert_selector "h1", text: "Appointments"
  end

  # will update this when we have more user roles and permissions defined

  # test "updating a Appointment" do
  #   visit appointment_url(@appointment)
  #   click_on "Edit", match: :first

  #   fill_in "Admin notes", with: @appointment.admin_notes
  #   fill_in "Billing notes", with: @appointment.billing_notes
  #   fill_in "Cancel reason code", with: @appointment.cancel_reason_code
  #   fill_in "Canceled by", with: @appointment.canceled_by
  #   fill_in "Confirmation date", with: @appointment.confirmation_date
  #   fill_in "Confirmation notes", with: @appointment.confirmation_notes
  #   fill_in "Confirmation phone", with: @appointment.confirmation_phone
  #   fill_in "Details", with: @appointment.details
  #   fill_in "Duration", with: @appointment.duration
  #   fill_in "Finish time", with: @appointment.finish_time
  #   fill_in "Gender req", with: @appointment.gender_req
  #   check "Home health appointment" if @appointment.home_health_appointment
  #   fill_in "Interpreter type", with: @appointment.interpreter_type
  #   fill_in "Lock version", with: @appointment.lock_version
  #   fill_in "Modality", with: @appointment.modality
  #   fill_in "Notes", with: @appointment.notes
  #   fill_in "Ref number", with: @appointment.ref_number
  #   fill_in "Start time", with: @appointment.start_time
  #   check "Status" if @appointment.status
  #   fill_in "Sub type", with: @appointment.sub_type
  #   fill_in "Time zone", with: @appointment.time_zone
  #   click_on "Update Appointment"

  #   assert_text "Appointment was successfully updated"
  #   assert_selector "h1", text: "Appointments"
  # end

  test "destroying a Appointment" do
    visit edit_appointment_url(@appointment)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Appointment was successfully destroyed"
  end
end
