require 'guard'
require 'guard/guard'
require 'guard/watcher'
require 'guard/go/runner'

module Guard
  class Go < Guard::Guard 
    attr_reader :options

    DEFAULT_OPTIONS = {
        :go_file => 'app.go'
    }
    
    def initialize(watchers = [], options = {})
      super

      @options = DEFAULT_OPTIONS.merge(options)
      @runner = Guard::GoRunner.new(@options)
    end

    # Call once when Guard starts. Please override initialize method to init stuff.
    # @raise [:task_has_failed] when start has failed
    def start
      run_all if options[:all_on_start]
    end

    def run_all
      run_on_change(Watcher.match_files(self, Dir.glob('{,**/}*{,.*}').uniq))
    end

    def run_on_change(paths)
      UI.info "Restarting Go..."
      if @runner.restart
        UI.info "Go restarted, pid #{runner.pid}"
      else
        UI.info "Go NOT restarted, check your log files."
      end
    end

    def stop
      Notifier.notify("Until next time...", :title => "Go shutting down.", :image => :pending)
      @runner.stop
    end
  end
end
