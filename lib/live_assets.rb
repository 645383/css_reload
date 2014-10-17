require "live_assets/engine"
require "thread"
require "listen"

module LiveAssets
  extend ActiveSupport::Autoload
  eager_autoload do
    autoload :SSESubscriber
  end

  mattr_reader :subscribers

  @@subscribers = []
  @@mutex = Mutex.new

  def self.subscribe(subscriber)
    @@mutex.synchronize do
      subscribers << subscriber
    end
  end

  def self.unsubscribe(subscriber)
    @@mutex.synchronize do
      subscribers.delete(subscriber)
    end
  end

  def self.start_listener(event, directories)
    Thread.new do
      lis = Listen.to(directories) do |_modified, _added, _removed|
        subscribers.each { |s| s << event }
      end
      lis.start
    end
  end

  def self.start_timer(event, time)
    Thread.new do
      while true
        subscribers.each { |s| s << event }
        sleep(time)
      end
    end
  end

end
