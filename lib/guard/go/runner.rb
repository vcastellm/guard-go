module Guard
  class GoRunner
    MAX_WAIT_COUNT = 10

    attr_reader :options, :pid

    def initialize(options)
      @options = options
      raise ArgumentError, "Server file not found. Check the :server option in your Guardfile." unless server_file_exists? or @options[:test]
    end

    def start
      run_go_command!
    end

    def stop
      ps_go_pid.each do |pid|
        system %{kill -KILL #{pid}}
      end
      while ps_go_pid.count > 0
        sleep sleep_time
      end
    end

    def restart
      stop
      start
    end

    def build_go_command
      if @options[:test]
        %{cd #{Dir.pwd} && go test #{@options[:package]}}
      else
        %{cd #{Dir.pwd} && go run #{@options[:server]} #{@options[:args_to_s]} &}
      end
    end

    def ps_go_pid
      `ps aux | awk '/a.out/&&!/awk/{print $2;}'`.split("\n").map { |pid| pid.to_i }
    end

    def sleep_time
      options[:timeout].to_f / MAX_WAIT_COUNT.to_f
    end

    private

    def run_go_command!
      system build_go_command
      @pid = $?.pid
    end

    def server_file_exists?
      File.exists? @options[:server]
    end
  end
end
