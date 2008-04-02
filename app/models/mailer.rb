class Mailer < ActionMailer::Base
  
  def community_created(community, url)
    @from = "#{APP_NAME} <do-not-reply@#{APP_DOMAIN}>"
    @subject = "Welcome to Thoughtlead!"
    @sent_on = Time.now
    @body[:community] = community
    @body[:url] = url
    @recipients = community.owner.email
  end  
  
  def user_to_user_email(from, to, email)
    @from = "#{from} <do-not-reply@#{APP_DOMAIN}>"
    @subject = email.subject
    @sent_on = Time.now
    @body[:email] = email
    @recipients = to.email
    @headers["reply-to"] = from.email
  end
  
end
