describe Terraspace::All::Grapher do
  Node = Terraspace::Dependency::Node

  let(:grapher) do
    grapher = described_class.new(format: "text")
    allow(grapher).to receive(:logger).and_return(logger)
    grapher
  end
  # To capture logger output for testing
  let(:logger) do
    @io = StringIO.new
    Logger.new(@io)
  end

  context "nodes" do
    it "text" do
      a1 = Node.new("a1")
      b1 = Node.new("b1")
      b2 = Node.new("b2")
      b1.parent!(a1)
      b2.parent!(a1)
      nodes = [a1,b1,b2]
      grapher.text(nodes)
      out = <<~EOL.chop # remove newline
        ├── a1
        │   ├── b1
        │   └── b2
        ├── b1
        └── b2
      EOL
      # remove the top line which is
      #     +I, [2020-09-09T13:44:33.822100 #22549]  INFO -- : .
      actual = @io.string.split("\n")[1..-1].join("\n")
      expect(actual).to eq(out)
    end

  end
end
