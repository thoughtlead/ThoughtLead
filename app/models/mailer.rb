class Mailer < ActionMailer::Base
  
  def community_created(community, url)
    @from = "#{APP_NAME} <do-not-reply@#{APP_DOMAIN}>"
    @subject = "Welcome to Thoughtlead!"
    @sent_on = Time.now
    @body[:community] = community
    @body[:url] = url
    @recipients = community.owner.email
  end  
  
end
