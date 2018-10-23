$:.push File.expand_path("../lib", __FILE__)

require "manageiq/providers/telefonica/version"

Gem::Specification.new do |s|
  s.name        = "manageiq-providers-telefonica"
  s.version     = ManageIQ::Providers::Telefonica::VERSION
  s.authors     = ["ManageIQ Developers"]
  s.homepage    = "https://github.com/ManageIQ/manageiq-providers-telefonica"
  s.summary     = "Telefonica Provider for ManageIQ"
  s.description = "Telefonica Provider for ManageIQ"
  s.licenses    = ["Apache-2.0"]

  s.files = Dir["{app,config,lib}/**/*"]

  s.add_runtime_dependency "activesupport",        ">= 5.0", "< 5.2"
  s.add_runtime_dependency "bunny",                "~>2.1.0"
  s.add_runtime_dependency "excon",                "~>0.40"
  s.add_runtime_dependency "fog-telefonica",        "=0.1.27"
  s.add_runtime_dependency "more_core_extensions", "~>3.2"

  s.add_development_dependency "codeclimate-test-reporter", "~> 1.0.0"
  s.add_development_dependency "simplecov"
end
