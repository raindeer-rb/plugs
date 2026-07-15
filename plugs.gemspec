# frozen_string_literal: true

require_relative 'lib/version'

Gem::Specification.new do |spec|
  spec.name = 'plugs'
  spec.version = Plugs::VERSION
  spec.authors = ['maedi']
  spec.email = ['maediprichard@gmail.com']

  spec.summary = 'Keep code loosely coupled, keep features tightly coupled'
  spec.description = <<~DESCRIPTION
    Plugs are dependencies that are loosely coupled internally but externally appear as one entity such as a feature, config object or plugin. 
    A plug is reusable, shareable and overridable.
  DESCRIPTION

  spec.homepage = 'https://github.com/raindeer-rb/plugs'
  spec.required_ruby_version = '>= 3.3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/raindeer-rb/plugs/src/branch/main'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('lib/**/*')
  end

  spec.require_paths = ['lib']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
end
