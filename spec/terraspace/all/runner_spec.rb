describe Terraspace::All::Runner do
  let(:runner) do
    runner = described_class.new(command: "up", yes: true)
    allow(runner).to receive(:build_batches).and_return(batches)
    allow(runner).to receive(:preview)
    # Just test to the point of the run_builder and deploy_batch
    allow(runner).to receive(:run_builder)
    allow(runner).to receive(:deploy_batch)
    # Take over logger
    allow(runner).to receive(:logger).and_return(logger)
    runner
  end
  # To capture logger output for testing
  let(:logger) do
    @io = StringIO.new
    Logger.new(@io)
  end

  context "simple batches" do
    let(:batches) do
      [
        set("c1"),
        set("b2", "b1"),
        set("a1"),
      ]
    end
    it "run" do
      runner.run
      expect(@io.string).to include "Batch Run 1"
      expect(@io.string).to include "Batch Run 2"
      expect(@io.string).to include "Batch Run 3"
    end
  end

  context "empty batches" do
    let(:batches) { [] }
    it "run" do
      runner.run
      expect(@io.string).to include "Time took" # just a sanity syntax check. dont think can really get here
    end
  end

  Node = Terraspace::Dependency::Node
  def set(*items)
    nodes = items.map { |i| Node.new(i) }
    Set.new(nodes)
  end
end
