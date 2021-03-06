# encoding: utf-8

require "spec_helper"

feature "User visits the blog" do

  it "has the site name" do
    Blogelator.site_name = "Brian's Blog"

    visit blogelator.root_path

    page.should have_content "Brian's Blog"
  end

  it "has default blog post when there are no published posts" do
    visit blogelator.root_path

    page.should have_content "Welcome to Blogelator"
    page.should have_content "Thanks for using Blogelator,"
  end

  it "has the 5 newest published posts by default" do
    create(:post, title: "Post 1", published_at: Time.now)
    create(:post, title: "Post 2", published_at: Time.now - 1.day)
    create(:post, title: "Post 3", published_at: Time.now - 2.days)
    create(:post, title: "Post 4", published_at: Time.now - 3.days)
    create(:post, title: "Post 5", published_at: Time.now - 4.days)
    create(:post, title: "Post 6", published_at: Time.now - 5.days)

    Blogelator.posts_per_page = nil

    visit blogelator.root_path

    page.should have_content "Post 1"
    page.should have_content "Post 2"
    page.should have_content "Post 3"
    page.should have_content "Post 4"
    page.should have_content "Post 5"

    page.should_not have_content "Post 6"
  end

  it "has the configured amount of newest published posts" do
    create(:post, title: "Post 1", published_at: Time.now)
    create(:post, title: "Post 2", published_at: Time.now - 1.day)
    create(:post, title: "Post 3", published_at: Time.now - 2.days)
    create(:post, title: "Post 4", published_at: Time.now - 3.days)
    create(:post, title: "Post 5", published_at: Time.now - 4.days)
    create(:post, title: "Post 6", published_at: Time.now - 5.days)

    Blogelator.posts_per_page = 3

    visit blogelator.root_path

    page.should have_content "Post 1"
    page.should have_content "Post 2"
    page.should have_content "Post 3"

    page.should_not have_content "Post 4"
    page.should_not have_content "Post 5"
    page.should_not have_content "Post 6"
  end

  it "has the summary of each blog post" do
    create(:post, title: "Post 1", published_at: Time.now)
    create(:long_post, title: "Post 2", published_at: Time.now - 1.day)

    visit blogelator.root_path

    page.should have_content "paragraph with some bold text"
    page.should have_content "This should be in the summary."
    page.should have_content "…"
    page.should_not have_content "This should not show up in the summary."
  end

  it "should take them to the post when they click the title" do
    post = create(:post, title: "Click Me Please!", published_at: Time.now)

    visit blogelator.root_path
    click_link("Click Me Please!")

    current_path.should eq(blogelator.post_path(post))
  end

  it "should show the full post when Blogelator.show_full_post is true" do
    Blogelator.show_full_post = true

    create(:long_post, published_at: Time.now)
    visit blogelator.root_path
    page.should have_content "This should not show up in the summary."

    Blogelator.show_full_post = false
  end

end
