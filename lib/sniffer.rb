require 'pcap'
require 'thread'

class MemcacheSniffer
  attr_accessor :metrics, :semaphore

  def initialize(config)
    @source  = config[:nic]
    @port    = config[:port]
    @host    = config[:host]
	
	@filter = config[:version]

    @metrics = {}
    @metrics[:calls]   = {}
    @metrics[:objsize] = {}
    @metrics[:reqsec]  = {}
    @metrics[:bw]    = {}
    @metrics[:stats]   = { :recv => 0, :drop => 0 }

    @semaphore = Mutex.new
  end

  def start
    cap = Pcap::Capture.open_live(@source, 1500)

    @metrics[:start_time] = Time.new.to_f

    @done    = false

    if @host == ""
      cap.setfilter("port #{@port}")
    else
      cap.setfilter("host #{@host} and port #{@port}")
    end

    cap.loop do |packet|

	if ((packet.raw_data =~ /set (\S+) \d+ \d+ (\d+)/) || (packet.raw_data =~ /delete (\S+)/))
		key   = $1
		if not self.isHint(key) 
			if self.filter(key)
				bytes = $2
				puts (key + " " + bytes)
			end
		end
      end

      break if @done
    end

    cap.close
  end
  
  def filter(key)
	if @filter == ""
		return true
	end
	return key.include? @filter
  end
  
  def isHint(key)
	return key.include? "_hint_"
  end

  def done
    @done = true
  end
end
