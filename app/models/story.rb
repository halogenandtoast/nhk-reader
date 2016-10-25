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
    fetched? ? super : fetch_body
  end

  private

  def fetch_body
    fetcher = NhkNewsEasy::BodyFetcher.new(url)

    fetcher.fetch.tap do |new_body|
      update(body: new_body, fetched: true)
    end
  end
end
