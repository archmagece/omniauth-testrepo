# frozen_string_literal: true

require_relative "lib/omniauth/kakao/version"

Gem::Specification.new do |spec|
  spec.name = "sb-omniauth-kakao"
  spec.version = Omniauth::Kakao::VERSION
  spec.authors = ["archmagece"]
  spec.email = ["archmagece@users.noreply.github.com"]

  spec.summary = "oauth strategy for OmniAuth 2.x"
  spec.description = "oauth strategy for OmniAuth 2.x"
  spec.homepage = "https://github.com/scriptonbasestar/sb-omniauth-kakao"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_dependency "jwt", ">= 2.10"
  spec.add_dependency "oauth2", "~> 2.0"
  spec.add_dependency "omniauth", "~> 2.1"
  spec.add_dependency "omniauth-oauth2", "~> 1.8"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "rspec-its", "~> 2.0"
  spec.add_development_dependency "rubocop", "~> 1.70"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
