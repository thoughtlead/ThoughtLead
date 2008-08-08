def determine_domain
  return "thoughtlead.com" if Rails.env == 'production'
  return "thoughtlead.intranet.ternarysoftware.com" if Rails.env == 'staging'
  return "thought.dev"
end

APP_DOMAIN = determine_domain
APP_PORT = Rails.env == 'production' ? "" : ":3000"
APP_HOST = APP_DOMAIN + APP_PORT
APP_NAME = "ThoughtLead"

IMAGE_DIMENSIONS = {:small => '48x48', :medium => '64x64', :large => '100x100'}
