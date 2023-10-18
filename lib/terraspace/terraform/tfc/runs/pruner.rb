class Terraspace::Terraform::Tfc::Runs
  class Pruner < Base
    include Terraspace::Terraform::Api::Client

    # @mod required for Api::Client
    def initialize(mod, options={})
      super
      @queue, @kept, @needs_pruning = [], nil, false
    end

    def run
      build_project
      build_queue
      are_you_sure?
      process_queue
    end

  private
    def build_queue
      runs.each do |item|
        next unless actionable?(item)
        unless @kept
          @kept = item
          next
        end
        queue(item)
        @needs_pruning = true
      end
    end

    def are_you_sure?
      unless @needs_pruning
        logger.info "Nothing to prune"
        return
      end

      keeping = item_message(@kept)
      items = @queue.map { |i| item_message(i) }.join("\n")
      message =<<~EOL
        Will keep:

        #{keeping}

        Will prune:

        #{items}

        Are you sure?
      EOL
      sure?(message.chop)
    end

    def item_message(item)
      p = ItemPresenter.new(item)
      "   #{p.id} #{p.status} #{p.message} #{p.created_at}"
    end

    def process_queue
      @queue.each do |item|
        process(item)
      end
    end

    def process(item)
      id = item['id']
      action = discardable?(item) ? "Discarded" : "Cancelled"
      p = ItemPresenter.new(item)
      msg = "#{action} #{p.id} #{p.message}" # note id is named run-xxx
      logger.info("NOOP: #{msg}") && return if ENV['NOOP']

      if discardable?(item)
        api.runs.discard(id)
      elsif cancelable?(item)
        api.runs.cancel(id)
      end
      logger.info msg
    end

    def queue(item)
      if discardable?(item)
        @queue << item
      elsif cancelable?(item)
        @queue << item
      end
    end

    # Docs seem to be off: https://www.terraform.io/docs/cloud/api/run.html#apply-a-run
    #
    #     This includes runs in the "pending," "needs confirmation," "policy checked," and "policy override" states.
    #
    # Cant really discard a "pending" status, but can discard a "planned" status.
    #
    def actionable?(item)
      discardable?(item) || cancelable?(item)
    end

    def discardable?(item)
      %w[planned].include?(status(item))
    end

    def cancelable?(item)
      %w[pending].include?(status(item))
    end

    def status(item)
      item['attributes']['status']
    end
  end
end
