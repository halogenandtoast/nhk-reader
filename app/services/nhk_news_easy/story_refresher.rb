module NhkNewsEasy
  class StoryRefresher
    DEFAULT_ATTRIBUTES = { fetched: false }

    def needs_refresh?
      news_might_be_available? && no_stories_fetched_today?
    end

    def refresh
      FeedFetcher.new.fetch_stories.each do |story|
        find_or_create_story(story.to_h)
      end
    end

    private

    def find_or_create_story(hash)
      attributes = DEFAULT_ATTRIBUTES.merge(hash)
      news_id = attributes[:news_id]

      ::Story.
        create_with(attributes).
        find_or_create_by(news_id: news_id)
    end

    def no_stories_fetched_today?
      ::Story.from_today.none?
    end

    def news_might_be_available?
      Date.today.on_weekday?
    end
  end
end
