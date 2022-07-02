module Terraspace::Cloud
  class Base < Terraspace::CLI::Base
    extend Memoist
    include Api::Concern
    include Context
    include Terraspace::Util

    def initialize(options={})
      super
      @cani = options[:cani]
      @kind = options[:kind]
      @vcs_vars = options[:vcs_vars]
      setup_context(options)
    end

    def stage_attrs(success)
      status = success_status(success)
      attrs = {
        status: status,
        kind: @kind,
        terraspace_version: check.terraspace_version,
        terraform_version: check.terraform_version,
      }
      attrs.merge!(@vcs_vars)
      attrs
    end

    def cloud_upload
      Upload.new(@options)
    end
    memoize :cloud_upload

    def success_status(success)
      case success
      when true then "success"
      when false then "fail"
      when nil then "started"
      end
    end

    def check
      Terraspace::CLI::Setup::Check.new
    end
    memoize :check

    def sh(command, exit_on_fail: true)
      logger.debug "=> #{command}"
      system command
      if $?.exitstatus != 0 && exit_on_fail
        logger.info "ERROR RUNNING: #{command}"
        exit $?.exitstatus
      end
    end

    def clean_cache2_stage
      # terraform plan can be a kind of apply or destroy
      # terraform apply can be a kind of apply or destroy
      kind = self.class.name.to_s.split('::').last.underscore # IE: apply or destroy
      dir = "#{@mod.cache_dir}/.terraspace-cache/.cache2/#{kind}"
      FileUtils.rm_rf(dir)
      FileUtils.mkdir_p(dir)
    end

    def record?
      changes? && !cancelled? || Terraspace.config.cloud.record == "all"
    end

    def changes?
      no_changes = Terraspace::Logger.buffer.detect do |line|
        line.include?('No changes')
      end
      zero_destroyed = Terraspace::Logger.buffer.detect do |line|
        line.include?('Destroy complete! Resources: 0 destroyed')
      end
      !no_changes && !zero_destroyed
    end

    def cancelled?
      !!Terraspace::Logger.buffer.detect do |line|
        line.include?(' cancelled')
      end
    end
  end
end
