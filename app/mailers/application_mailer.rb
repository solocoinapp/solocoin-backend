class ApplicationMailer < ActionMailer::Base
  default from: 'CoronaGo <admin@coronagoapp.com>', reply_to: 'admin@coronagoapp.com'
  layout 'mailer'
end
