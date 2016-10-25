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
    Story.by_publication_date
  end

  def needs_refresh?
    Date.today.on_weekday? && Story.where(published_at: Time.current.all_day).none?
  end

  def refresh_stories
    NhkNewsEasy::Fetcher.new.fetch_stories.each do |story|
      attributes = { fetched: false }.merge(story.to_h)
      Story.create_with(attributes).find_or_create_by(news_id: story.id)
    end
  end
end
