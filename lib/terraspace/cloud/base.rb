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
      @success = options[:success]
      setup_context(options)
    end

    def stage_attrs
      status = @success ? "success" : "fail"
      attrs = {
        status: status,
        kind: @kind,
        terraspace_version: check.terraspace_version,
        terraform_version: check.terraform_version,
      }
      attrs.merge!(ci_vars) if ci_vars
      attrs
    end

    def check
      Terraspace::CLI::Setup::Check.new
    end
    memoize :check

    def pr_comment(url)
      ci.comment(url) if ci.respond_to?(:comment)
    end

    def ci_vars
      return unless ci
      if ci.vars[:host]
        vcs = Ci::Vcs.new(ci.vars)
        vcs.merged_vars
      else
        ci.vars
      end
    end

    def ci
      Terraspace::Cloud::Ci.detect
    end
    memoize :ci

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

    def terraspace_cloud_info(result)
      data = result['data']
      url = data['attributes']['url']
      logger.info "Terraspace Cloud #{url}"
      url
    end
  end
end
