require 'thread'

module Bioportal

  # Parallel downloader for Submissions
  module Downloader
    def self.run(num_threads=10)
      queue = Queue.new

      # Create jobs
      Bioportal::Submission.includes(:ontology).each do |obj|
        queue << obj unless obj.downloaded?
      end

      puts "Starting #{num_threads} workers with #{queue.size} jobs".green

      # Create and start threads
      threads = num_threads.times.map do |i|
        Thread.new do
          begin
            while obj = queue.pop(true)
              puts "[#{i}] Downloading ##{obj.id} (#{obj})"
              begin
                obj.download
              rescue Exception => e
                STDERR.puts "[#{i}] Submission ##{obj.id}: #{e.message}".red
              end
            end
          rescue ThreadError => e
            puts "[#{i}] finished".green
          end
        end
      end
      
      # Wait for threads to finish
      threads.each(&:join)
      puts "All workers done".green
    end
  end

end
