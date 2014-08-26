# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
    spec.name          = 'stl'
    spec.version       = '0.2'
    spec.authors       = ["Brandon Fosdick"]
    spec.email         = ["bfoz@bfoz.net"]
    spec.description   = %q{Read and write STL files}
    spec.summary       = %q{Read, write and manipulate stereolithography files}
    spec.homepage      = 'https://github.com/bfoz/stl-ruby'
    spec.license       = 'BSD'

    spec.files         = `git ls-files -z`.split("\x0")
    spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
    spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
    spec.require_paths = ["lib"]

    spec.add_development_dependency "bundler", "~> 1.5"
    spec.add_development_dependency "rake"

    spec.add_dependency	'geometry'
end
