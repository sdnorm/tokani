require "test_helper"

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @appointment = appointments(:one)
  end

  test "should get index" do
    get appointments_url
    assert_response :success
  end

  test "should get new" do
    get new_appointment_url
    assert_response :success
  end

  test "should create appointment" do
    assert_difference("Appointment.count") do
      post appointments_url, params: { appointment: { admin_notes: @appointment.admin_notes, billing_notes: @appointment.billing_notes, cancel_reason_code: @appointment.cancel_reason_code, canceled_by: @appointment.canceled_by, confirmation_date: @appointment.confirmation_date, confirmation_notes: @appointment.confirmation_notes, confirmation_phone: @appointment.confirmation_phone, details: @appointment.details, duration: @appointment.duration, finish_time: @appointment.finish_time, gender_req: @appointment.gender_req, home_health_appointment: @appointment.home_health_appointment, interpreter_type: @appointment.interpreter_type, lock_version: @appointment.lock_version, modality: @appointment.modality, notes: @appointment.notes, ref_number: @appointment.ref_number, start_time: @appointment.start_time, status: @appointment.status, sub_type: @appointment.sub_type, time_zone: @appointment.time_zone } }
    end

    assert_redirected_to appointment_url(Appointment.last)
  end

  test "should show appointment" do
    get appointment_url(@appointment)
    assert_response :success
  end

  test "should get edit" do
    get edit_appointment_url(@appointment)
    assert_response :success
  end

  test "should update appointment" do
    patch appointment_url(@appointment), params: { appointment: { admin_notes: @appointment.admin_notes, billing_notes: @appointment.billing_notes, cancel_reason_code: @appointment.cancel_reason_code, canceled_by: @appointment.canceled_by, confirmation_date: @appointment.confirmation_date, confirmation_notes: @appointment.confirmation_notes, confirmation_phone: @appointment.confirmation_phone, details: @appointment.details, duration: @appointment.duration, finish_time: @appointment.finish_time, gender_req: @appointment.gender_req, home_health_appointment: @appointment.home_health_appointment, interpreter_type: @appointment.interpreter_type, lock_version: @appointment.lock_version, modality: @appointment.modality, notes: @appointment.notes, ref_number: @appointment.ref_number, start_time: @appointment.start_time, status: @appointment.status, sub_type: @appointment.sub_type, time_zone: @appointment.time_zone } }
    assert_redirected_to appointment_url(@appointment)
  end

  test "should destroy appointment" do
    assert_difference("Appointment.count", -1) do
      delete appointment_url(@appointment)
    end

    assert_redirected_to appointments_url
  end
end
