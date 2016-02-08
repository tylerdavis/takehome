class CrawlJob < ActiveJob::Base
  queue_as :default

  def perform(crawl)
    crawl.process
  end
end
