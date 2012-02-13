ActionMailer::Base.smtp_settings = {
  :address        => Settings.mailer.address,
  :port           => Settings.mailer.port,
  :authentication => :plain,
  :user_name      => Settings.mailer.user_name,
  :password       => Settings.mailer.password,
  :domain         => Settings.mailer.domain
}