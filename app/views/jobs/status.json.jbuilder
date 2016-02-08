json.completed @job.crawls.where(in_progress: false).count
json.inprogress @job.crawls.where(in_progress: true).count