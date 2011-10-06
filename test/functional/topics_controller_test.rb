require "test_helper"

class TopicsControllerTest < ActionController::TestCase
  test "shows topic title and description" do
    topic = create(:topic)
    get :show, id: topic.to_param
    assert_select ".topic .name", text: topic.name
    assert_select ".topic .description", text: topic.description
  end

  test "shows only published policies associated with topic" do
    published_edition = create(:published_edition)
    draft_edition = create(:draft_edition)
    topic = create(:topic, editions: [published_edition, draft_edition])
    get :show, id: topic.to_param
    assert_select_object(published_edition)
    assert_select_object(draft_edition, count: 0)
  end

  test "shows only published publications associated with topic" do
    published_edition = create(:published_edition, document: build(:publication))
    draft_edition = create(:draft_edition, document: build(:publication))
    topic = create(:topic, editions: [published_edition, draft_edition])
    get :show, id: topic.to_param
    assert_select_object(published_edition)
    assert_select_object(draft_edition, count: 0)
  end

  test "should not display an empty published policies section" do
    topic = create(:topic)
    get :show, id: topic.to_param
    assert_select "#policies", count: 0
  end

  test "should not display an empty published publications section" do
    topic = create(:topic)
    get :show, id: topic.to_param
    assert_select "#publications", count: 0
  end
end