# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "mcsnif"
  gem.version       = "0.0.1"
  gem.authors       = ["Yaroslav Ionov"]
  gem.email         = [""]
  gem.description   = %q{mcsnif - a realtime memcache key analyzer}
  gem.summary       = %q{mcsnif - an interactive terminal app for analyzing memcache key activity make sure you have the libpcap development libraries installed for the dependencies}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'ruby-pcap', '~> 0.7.8'
  gem.add_runtime_dependency 'curses', '~> 1.0.1'
end
