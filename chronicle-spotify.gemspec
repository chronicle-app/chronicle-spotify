lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chronicle/spotify/version'

Gem::Specification.new do |spec|
  spec.name          = 'chronicle-spotify'
  spec.version       = Chronicle::Spotify::VERSION
  spec.authors       = ['Andrew Louis']
  spec.email         = ['andrew@hyfen.net']

  spec.summary       = 'Spotify importer for Chronicle'
  spec.description   = 'Spotify connectors'
  spec.homepage      = 'https://github.com/chronicle-app/chronicle-spotify'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/chronicle-app/chronicle-spotify'
    spec.metadata['changelog_uri'] = 'https://github.com/chronicle-app/chronicle-spotify'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.1'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'chronicle-core', '~> 0.3'
  spec.add_dependency 'chronicle-etl', '~> 0.6'
  spec.add_dependency 'omniauth-spotify'
  spec.add_dependency 'rspotify', '~> 2.11'

  spec.add_development_dependency 'bundler', '~> 2.3'
  spec.add_development_dependency 'pry-byebug', '~> 3.10'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.63'
end
