module Terraspace::CLI::Concerns
  module SourceDirs
    # used by list
    def source_dirs
      Dir.glob("{app,vendor}/{modules,stacks}/*").select { |p| File.directory?(p) }.sort
    end

    # dont include vendor: used by fmt
    def app_source_dirs
      Dir.glob("{app}/{modules,stacks}/*").select { |p| File.directory?(p) }.sort
    end
  end
end
