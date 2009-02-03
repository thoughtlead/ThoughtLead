require File.dirname(__FILE__) + '/../test_helper'

class ResponsesControllerTest < ActionController::TestCase
  context "When a user is  subscribed to a discussion" do
    setup do
      ActionMailer::Base.deliveries = []
      @community = Community.make
      @discussion = Discussion.make(:community => @community)
      @subscriber = User.make(:community => @community)
      @email_subscription = EmailSubscription.create(:discussion => @discussion, :subscriber => @subscriber)
    end

    context "when a response is added to the discussion" do
      setup do
        new_request(@community, @subscriber)
        @response_text = "Response text"
        post :create, { :discussion_id => @discussion.id, :response => {:body => @response_text }}
      end

      should "send email to all subscribers" do
        assert_sent_email do |email|
          email.subject =~ /New response from/ &&
          email.to.include?(@subscriber.email) &&
          email.body =~ /#{@response_text}/
        end
      end
    end

    context "when an empty response is posted" do
      setup do
        new_request(@community, @subscriber)
        post :create, { :discussion_id => @discussion.id, :response => {:body => "" }}
      end

      should "stay on the discussion page, as usual" do
        assert_response :redirect
      end

      should "not send email to all subscribers" do
        assert_did_not_send_email
      end
    end

  end
end
