class StoriesController < ApplicationController
  def index
    @stories = fetch_stories
  end

  def show
    @story = Story.find_by(news_id: params[:id])
  end

  private

  def fetch_stories
    refresh_stories if needs_refresh?
    Story.by_publication_date.page(params[:page])
  end

  def needs_refresh?
    story_refresher.needs_refresh?
  end

  def refresh_stories
    story_refresher.refresh
  end

  def story_refresher
    @_story_refresher ||= NhkNewsEasy::StoryRefresher.new
  end
end
