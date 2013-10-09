require 'thread'

module Bioportal

  # Parallel downloader for Submissions
  module Downloader
    def self.run(num_threads=10)
      queue   = Queue.new
      threads = []

      # Create jobs
      Bioportal::Submission.includes(:ontology).each do |obj|
        queue << obj unless obj.downloaded?
      end

      # Create and start threads
      num_threads.times do |i|
        threads << Thread.new do
          while obj = queue.pop(true)
            puts "[#{i}] Downloading #{obj}"
            begin
              obj.download
            rescue DownloadError => e
              STDERR.puts "[#{i}] #{e.message}"
            end
          end
        end
      end
      
      # Wait for threads to finish
      threads.each(&:join)
    end
  end

end