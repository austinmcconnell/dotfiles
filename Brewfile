# Entry-point Brewfile — aggregates all topic-specific Brewfiles.
# Usage:
#   brew bundle --file=Brewfile              # install all packages
#   brew bundle check --file=Brewfile        # drift detection
#   brew bundle cleanup --file=Brewfile      # show orphaned packages
#   brew bundle cleanup --file=Brewfile --force  # remove orphaned packages

def personal?
  ENV["HOMEBREW_IS_WORK_COMPUTER"] != "1"
end

Dir.glob("#{__dir__}/install/**/*.Brewfile").sort.each do |f|
  eval(File.read(f), binding, f)
end
