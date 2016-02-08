class Job < ActiveRecord::Base
  has_many :crawls

  def self.new_with_urls(urls)

    job = Job.new

    job.errors.add(:urls, 'must be an array') unless urls.present? && urls.is_a?(Array)

    urls.each do |url|
      job.errors.add(:urls, "`#{url}` is not a valid url") unless Job.valid_url?(url)
    end

    return job if job.errors.any?

    job.crawls = urls.map { |url| Crawl.new(url: url) }

    job

  end

  def self.valid_url?(url)
    !!URI.parse(url)
  rescue URI::InvalidURIError
    false
  end

end