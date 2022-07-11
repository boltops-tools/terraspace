class Terraspace::Cloud::Cost
  class Infracost
    extend Memoist
    include Terraspace::Util::Popen

    def initialize(options={})
      @cloud_stack_name = options[:cloud_stack_name]
    end

    def name
      "infracost"
    end

    def run(output_dir=".terraspace-cache/.cache2/cost")
      unless infracost_installed?
        logger.info "WARN: infracost not installed. Please install infracost first: https://www.infracost.io/docs/".color(:yellow)
        logger.info "Not running cost estimate"
        return false
      end
      unless api_key?
        logger.info "WARN: infracost api key not configured. Please set the environment variable INFRACOST_API_KEY".color(:yellow)
        logger.info "Not running cost estimate"
        return false
      end

      previous_cost_available = File.exist?("#{output_dir}/cost_prev.json")
      commands = [
        "infracost breakdown --path . --format json --out-file #{output_dir}/cost.json --project-name #{@cloud_stack_name}",
      ]
      if previous_cost_available
        commands << "infracost diff --path #{output_dir}/cost.json --compare-to=#{output_dir}/cost_prev.json --format json --out-file #{output_dir}/cost_diff.json"
      end

      cost_json_file = previous_cost_available ? "cost_diff.json" : "cost.json"
      commands += [
        "infracost output --path #{output_dir}/#{cost_json_file} --format html  --out-file #{output_dir}/cost.html",
        "infracost output --path #{output_dir}/#{cost_json_file} --format table --out-file #{output_dir}/cost.text",
      ]

      if comment_format
        path = previous_cost_available ? "cost_diff.json" : "cost.json"
        commands << "infracost output --path #{output_dir}/#{path} --format #{comment_format} --out-file #{output_dir}/cost.comment"
      end

      commands.each do |command|
        logger.debug "=> #{command}"

        popen(command, filter: "Output saved to ")
        if command.include?(".text")
          logger.info IO.read("#{output_dir}/cost.text")
          logger.info "\n"
        end
      end
    end

    def comment_format
      name = Terraspace::Cloud::Vcs.detect_name # IE: github
      format = "#{name}-comment"
      # These are valid infracost comment format. Note: Not all have terraspace_vcs_* plugin support yet
      valid = %w[github-comment gitlab-comment azure-repos-comment bitbucket-comment]
      format if valid.include?(format)
    end

    def version
      out = `infracost --version`.strip # Infracost v0.10.6
      md = out.match(/ v(.*)/)
      md ? md[1] : out
    end
    memoize :version

    def infracost_installed?
      system "type infracost > /dev/null 2>&1"
    end

    def api_key?
      return true if ENV['INFRACOST_API_KEY']
      File.exist?("#{ENV['HOME']}/.config/infracost/credentials.yml")
    end
  end
end
