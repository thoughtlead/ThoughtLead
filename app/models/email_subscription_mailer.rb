class EmailSubscriptionMailer < ActionMailer::Base

  def self.deliver_discussion_updates(subscribers, response)
    subscribers.each do |subscriber|
      deliver_discussion_update(subscriber, response)
    end
  end

  def discussion_created(subscriber, discussion)
    setup_email subscriber
    subject "A new discussion has begun at #{subscriber.community.name}"
    body :subscriber => subscriber, :discussion => discussion
  end

  def discussion_update(subscriber, response)
    setup_email subscriber
    subject "New response from #{response.user.display_name} for the discussion: #{response.discussion.title}"
    body :subscriber => subscriber, :response => response
  end

  private

  def setup_email(to)
    from "#{APP_NAME} <do-not-reply@#{APP_DOMAIN}>"
    sent_on Time.now
    recipients to.respond_to?(:email) ? to.email : to
    headers "x-custom-ip-tag" => "thoughtlead"
  end
end
