# Preview all emails at http://localhost:3000/rails/mailers/tokani_agency_creation_mailer
class TokaniAgencyCreationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/tokani_agency_creation_mailer/welcome
  def welcome
    TokaniAgencyCreationMailer.welcome
  end

end
