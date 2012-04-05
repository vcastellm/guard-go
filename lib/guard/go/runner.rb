require 'fileutils'

module Guard
  class Go
    class Runner
      MAX_WAIT_COUNT = 10

      attr_reader :options

      def initialize(options)
        @options = options
      end

      def start
        run_rails_command!
        wait_for_pid
      end

      def stop
        if File.file?(pid_file)
          system %{kill -KILL #{File.read(pid_file).strip}}
          wait_for_no_pid if $?.exitstatus == 0
          FileUtils.rm pid_file
        end
      end

      def restart
        stop
        start
      end

      def build_go_command
        %{sh -c 'cd #{Dir.pwd} && go run #{options[:go_file]} &'}
      end

      def pid_file
        File.expand_path("tmp/pids/#{options[:go_file]}.pid")
      end

      def pid
        File.file?(pid_file) ? File.read(pid_file).to_i : nil
      end

      def sleep_time
        options[:timeout].to_f / MAX_WAIT_COUNT.to_f
      end

      private
      def run_go_command!
        system build_go_command
        system %{echo $! > #{pid_file}}
      end

      def has_pid?
        File.file?(pid_file)
      end

      def wait_for_pid_action
        sleep sleep_time
      end

      def wait_for_pid
        wait_for_pid_loop
      end

      def wait_for_pid_loop
        count = 0
        while !has_pid? && count < MAX_WAIT_COUNT
          wait_for_pid_action
          count += 1
        end
        !(count == MAX_WAIT_COUNT)
      end
    end
  end
end
