require 'optparse'
require 'pcap'

class CmdLine
  def self.parse(args)
    @config = {}

    opts = OptionParser.new do |opt|
      opt.on('-i', '--interface=NIC', 'Network interface to sniff (required)') do |nic|
        @config[:nic] = nic
      end

      @config[:host] = ''
      opt.on('--host=HOST', 'Network host to sniff on (default all)') do |host|
        @config[:host] = host
      end

      @config[:port] = 11211
      opt.on('-p', '--port=PORT', 'Network port to sniff on (default 11211)') do |port|
        @config[:port] = port
      end
	  
      @config[:version] = ''
      opt.on('-v', '--version=VERSION', 'Key string to filter (for example beta, demo, etc)') do |port|
        @config[:version] = version
      end	  

    end

    opts.parse!

    # bail if we're not root
    unless Process::Sys.getuid == 0
      puts "** ERROR: needs to run as root to capture packets"
      exit 1
    end

    # we need need a nic to listen on
    unless @config.has_key?(:nic)
      puts "** ERROR: You must specify a network interface to listen on"
      puts opts
      exit 1
    end

    # we can't do 'any' interface just yet due to weirdness with ruby pcap libs
    if @config[:nic] =~ /any/i
      puts "** ERROR: can't bind to any interface due to odd issues with ruby-pcap"
      puts opts
      exit 1
    end

    @config
  end
end
