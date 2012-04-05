require "guard-go/go/version"
require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class Go < Guard::Guard 
    attr_reader :options, :runner

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
      if runner.restart
        UI.info "Rack restarted, pid #{runner.pid}"
        Notifier.notify("Rack restarted on port #{options[:port]}.", :title => "Rack restarted!", :image => :success)
      else
        UI.info "Rack NOT restarted, check your log files."
        Notifier.notify("Rack NOT restarted, check your log files.", :title => "Rack NOT restarted!", :image => :failed)
      end
    end

    def stop
      Notifier.notify("Until next time...", :title => "Go shutting down.", :image => :pending)
      runner.stop
    end
  end
end
