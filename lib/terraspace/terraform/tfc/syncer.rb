module Terraspace::Terraform::Tfc
  class Syncer < Terraspace::CLI::Base
    extend Memoist
    include Terraspace::Compiler::DirsConcern
    include Terraspace::Util::Sure

    def run
      are_you_sure?
      mods.each do |mod|
        run_sync(mod)
      end
    end

    def mods
      stacks = @options[:stacks]
      stacks.empty? ? stack_names : stacks
    end

    def run_sync(mod)
      sync(mod).run
    end

    def sync(mod)
      Sync.new(@options.merge(mod: mod))
    end
    memoize :sync

    def are_you_sure?
      message =<<~EOL
        About to sync these project stacks with Terraform Cloud workspaces:

            Stack => Workspace
      EOL

      mods.each do |mod|
        sync = sync(mod)
        message << "    #{mod} => #{sync.workspace_name}\n"
      end
      message << <<~EOL

        A sync does the following for each workspace:

          1. Create or update workspace, including the VCS settings.
          2. Set the working dir.
          3. Set env and terraform variables.

        Are you sure?
      EOL
      sure?(message.chop)
    end
  end
end
