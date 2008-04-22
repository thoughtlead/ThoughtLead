def determine_domain
  return "thoughtlead.com" if Rails.env == 'production'
  return "thoughtlead.verticality.dock.terralien.biz" if Rails.env == 'staging'
  return "thought.dev"
end

APP_DOMAIN = determine_domain
APP_PORT = RAILS_ENV == 'development' ? ":3000" : ""
APP_NAME = "ThoughtLead"


