require 'open-uri'
require 'open_uri_redirections'


class Crawl < ActiveRecord::Base
  has_many :crawls
  serialize :images, Array

  attr_accessor :document

  validates :url, :format => URI::regexp(%w(http https))

  after_commit :process_async, on: :create

  def child_hrefs
    links = @document.css('a')
    # 1. Grab all of the a tags, and their href attributes. Trim dups and sort
    # 2. Remove any empties or anchor tags
    # 3. Convert relative URLs to fully qualified
    links.map { |link| link.attribute('href').to_s }.uniq.sort
      .delete_if { |href| href.empty? || href.start_with?('#') }
      .map { |href| URI.join(self.url, href).to_s }
  end

  def image_sources
    # Pull all image tags from document and parse unique sources
    images = @document.css('img')
    sources = images.map { |img| img.attribute('src').to_s.gsub(/\?.*/, '') }.uniq.sort

    sources.delete_if do |src|
      # Check the extension against allowed file types
      src.empty? || %w(.png .jpg .gif).exclude?(Pathname(src).extname)
    end
  end

  def process

    begin
      page = open(self.url)
    rescue => e
      if e.class == RuntimeError && self.url.exclude?('https')
        Rails.logger.info("Crawler encountered SSL redirect on url:#{self.url}")
        page = open(self.url.gsub('http', 'https'))
      end
    end

    @document = Nokogiri::HTML(page)
    # We only want to go two levels deep, so, we'll create a crawl for all children, only if we are a parent
    if parent?
      self.child_hrefs.each { |url| Crawl.create(crawl_id: self.id, url: url, job_id: self.job_id) }
    end
    self.images = self.image_sources
    self.in_progress = false
    self.save
  end

  def process_async
    CrawlJob.perform_later(self)
  end

  def child?
    self.crawl_id.present?
  end

  def parent?
    self.crawl_id.nil?
  end

end
