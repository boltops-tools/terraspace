module Terraspace::All
  class Summary
    include Terraspace::CLI::Log::Concern
    include Terraspace::Util::Logging

    def initialize(data={})
      @data = data
      @command = data[:command]
      @log_path = data[:log_path]
      @terraspace_command = data[:terraspace_command]
    end

    @@header_shown = false
    def run
      @lines = readlines(@log_path)
      if respond_to?(@command.to_sym)
        send(@command)
      else
        default
      end
      summarize
    end

    # Examples of "complete" line:
    #     [2020-09-06T21:58:25 #11313 terraspace up b1]: Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
    #     [2020-09-07T08:28:15 #26093 terraspace down a1]: Destroy complete! Resources: 2 destroyed.
    #
    # handles: up and down
    def default
      @lines.select! do |line|
        line.include?("complete! Resources:") || # success: handles both apply and destroy output
        line.include?("Changes to Outputs") ||
        line.include?("No changes") ||
        line.include?("Error: ")  # error
      end
    end

    # Example 1:
    #     [2020-09-07T14:45:14 #23340 terraspace plan b1]: No changes. Infrastructure is up-to-date.
    # Example 2:
    #     [2020-09-07T14:46:58 #31974 terraspace plan b1]: Changes to Outputs:
    #     [2020-09-07T14:46:58 #31974 terraspace plan b1]:   ~ length = 1 -> 2
    def plan
      @lines.select! do |line|
        line.include?("No changes. Infrastructure") ||
        line.include?("Changes to Outputs") ||
        line.include?("Plan:") ||
        line.include?("Changes to ") ||
        line.include?("Error: ")  # error
      end
    end

    def output
      @lines # pass through all output info
    end

    def show
      resources = @lines.grep(/: resource "/).count
      outputs = count_outputs(@lines)
      summary = "Resources: #{resources} Outputs: #{outputs}"
      # get summary line before running select! which will remove lines
      @lines.select! do |line|
        line.include?("Error: ")  # error
      end
      @lines.unshift(summary) # add to top
    end

    # [2020-09-07T14:53:36 #31106 terraspace show b1]: Outputs:
    # [2020-09-07T14:53:36 #31106 terraspace show b1]:
    # [2020-09-07T14:53:36 #31106 terraspace show b1]: length = 1
    # [2020-09-07T14:53:36 #31106 terraspace show b1]: length2 = 2
    # [2020-09-07T14:53:36 #31106 terraspace show b1]: random_pet_id = "corgi"
    def count_outputs(lines)
      count = 0
      counting = false
      lines.each do |line|
        counting ||= line.include?(": Outputs:")
        count += 1 if counting && line.include?(' = ')
      end
      count
    end

    # [2020-09-07T13:51:45 #21323 terraspace validate a1]: Success! The configuration is valid.
    def validate
      @lines.select! do |line|
        line.include?("The configuration is") || # success
        line.include?("Error: ")  # error
      end
    end

  private
    def summarize
      @lines.each do |line|
        line.sub!(/.*\]:\s+/, ' ') # remove log info from line
        logger.info("#{@terraspace_command}: #{line}")
      end
    end
  end
end
