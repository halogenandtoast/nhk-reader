class Story < ApplicationRecord
  scope :by_publication_date, -> { order published_at: :desc }
  scope :from_today, -> { where(published_at: Time.current.all_day) }

  def to_param
    news_id
  end

  def published_on
    published_at.to_date
  end

  def body
    fetched? ? super : fetch { super }
  end

  def image
    fetched? ? super : fetch { super }
  end
  alias has_image? image

  private

  def fetch
    fetch_body
    fetch_image
    update(fetched: true)
    yield
  end

  def fetch_body
    fetcher = NhkNewsEasy::BodyFetcher.new(url)
    self.body = fetcher.fetch
  end

  def fetch_image
    fetcher = NhkNewsEasy::ImageFetcher.new(data["news_web_image_uri"])
    self.image = fetcher.fetch
  end
end
