require "open-uri"

module NhkNewsEasy
  # URL
  #
  # http://www3.nhk.or.jp/news/easy/k10010741501000/k10010741501000.html
  #
  # Structure
  #
  # {
  #   "news_priority_number": "5",
  #   "news_prearranged_time": "2016-09-26 11:30:00",
  #   "news_id": "k10010703121000",
  #   "title": "韓国　ピョンチャンオリンピックの記念の硬貨ができる",
  #   "title_with_ruby": "<ruby>韓国<rt>かんこく</rt></ruby>　ピョンチャンオリンピックの<ruby>記念<rt>きねん</rt></ruby>の<ruby>硬貨<rt>こうか</rt></ruby>ができる",
  #   "news_file_ver": false,
  #   "news_creation_time": "2016-10-24 17:05:06",
  #   "news_preview_time": "2016-10-24 17:05:06",
  #   "news_publication_time": "2016-10-24 11:43:25",
  #   "news_publication_status": true,
  #   "has_news_web_image": false,
  #   "has_news_web_movie": false,
  #   "has_news_easy_image": false,
  #   "has_news_easy_movie": false,
  #   "has_news_easy_voice": true,
  #   "news_web_image_uri": "",
  #   "news_web_movie_uri": "",
  #   "news_easy_image_uri": "''",
  #   "news_easy_movie_uri": "''",
  #   "news_easy_voice_uri": "k10010703121000.mp3",
  #   "news_display_flag": true,
  #   "news_web_url": "http://www3.nhk.or.jp/news/html/20160922/k10010703121000.html"
  # }
  class Story
    def initialize(json)
      @json = json
    end

    def date
      DateTime.parse(json["news_prearranged_time"])
    end

    def title
      json["title"]
    end

    def title_with_ruby
      json["title_with_ruby"]
    end

    def id
      json["news_id"]
    end

    def to_h
      {
        title: title,
        title_with_ruby: title_with_ruby,
        news_id: id,
        published_at: date,
        url: url
      }
    end

    def url
      "http://www3.nhk.or.jp/news/easy/#{id}/#{id}.html"
    end

    private

    attr_reader :json
  end

  class Feed
    def initialize(json)
      @json = json
    end

    def stories
      days.inject([]) do |stories, day|
        stories + json[day].map { |story_json| Story.new(story_json) }
      end
    end

    private

    attr_reader :json

    def days
      @_days ||= json.keys.sort { |a, b| b <=> a }
    end
  end

  class Fetcher
    BASE_URL = "http://www3.nhk.or.jp/news/easy/news-list.json?_=1477355365671"
    DEFAULT_ENCODING = "UTF-8"
    BOM = "\xEF\xBB\xBF".force_encoding(DEFAULT_ENCODING)

    def fetch_stories
      Feed.new(fetch_json).stories
    end

    private

    def fetch_json
      io = open(url)
      contents = io.read.force_encoding(DEFAULT_ENCODING).sub!(BOM, "")
      JSON.parse(contents).first # The whole structure is wrapped in an array for some reason
    end

    def url
      BASE_URL + timestamp.to_s
    end

    def timestamp
      (Time.now.to_f * 1000).to_i
    end
  end
end
