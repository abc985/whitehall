require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  enable_url_helpers
  
  setup do
    @policy = create(:draft_edition)
    @email_address_of_fact_checker = 'fact-check@example.com'
    @mail = Notifications.fact_check(@policy, @email_address_of_fact_checker)
  end
  
  test "fact check should be sent to the specified email address" do
    assert_equal [@email_address_of_fact_checker], @mail.to
  end
  
  test "fact check should be sent from a generic email address" do
    assert_equal ["fact-check-request@#{Whitehall.domain}"], @mail.from
  end
  
  test "fact check subject" do
    assert_equal "Fact checking request", @mail.subject
  end
    
  test "fact check email should contain a policy link containing a token" do
    assert_match /#{admin_edition_url(@policy)}\?token=.+/, @mail.body.to_s
  end
end