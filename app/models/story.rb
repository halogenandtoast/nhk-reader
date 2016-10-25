class Story < ApplicationRecord
  scope :by_publication_date, -> { order published_at: :desc }

  def to_param
    news_id
  end

  def published_on
    published_at.to_date
  end

  def body
    if fetched?
      super
    else
      NhkNewsEasy::BodyFetcher.new(url).fetch.tap do |new_body|
        update(body: new_body, fetched: true)
      end
    end
  end
end
