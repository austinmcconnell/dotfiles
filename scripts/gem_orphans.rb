#!/usr/bin/env ruby
# Find orphaned gems not tracked in default-gems or their transitive dependencies.
# Usage: ruby gem_orphans.rb /path/to/default-gems

require 'set'

default_gems_file = ARGV[0]
tracked = File.readlines(default_gems_file).map(&:strip).reject { |l| l.empty? || l.start_with?('#') }

# Recursively resolve all dependencies of tracked gems
all_tracked = Set.new(tracked)
queue = tracked.dup
visited = Set.new

until queue.empty?
  gem_name = queue.shift
  next if visited.include?(gem_name)
  visited.add(gem_name)

  spec = Gem::Specification.find_by_name(gem_name)
  spec.dependencies.each do |dep|
    next unless dep.type == :runtime
    all_tracked.add(dep.name)
    queue.push(dep.name) unless visited.include?(dep.name)
  end
rescue Gem::MissingSpecError
  next
end

# Get all installed non-default gems
installed = Gem::Specification.select { |s| !s.default_gem? }.map(&:name).uniq

# Report orphans
orphans = installed.sort - all_tracked.to_a.sort
orphans.each { |g| puts g }
