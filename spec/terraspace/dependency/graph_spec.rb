describe Terraspace::Dependency::Graph do
  let(:graph) { described_class.new(stack_names, dependencies, options) }
  let(:options) { {} }

  context "simple" do
    let(:stack_names) { ["a1", "b2", "b1", "c1"] }
    let(:dependencies) do
      ["a1:b1", "b1:c1","a1:b1", "a1:b2", "a1:b1", "b2:c1"]
    end
    it "build" do
      batches = normalize(graph.build)
      # └── a1
      #     ├── b1
      #     │   └── c1
      #     └── b2
      #         └── c1
      expect(batches).to eq(
        [
          ["c1"],
          ["b1", "b2"],
          ["a1"]
        ]
      )
    end
  end

  context "complex" do
    let(:stack_names) { ["a1", "b4", "a2", "b2", "e1", "b1", "b3", "a3", "c1", "c3", "d1", "c2"] }
    let(:dependencies) do
      ["a1:b1",
       "a1:b2",
       "a1:b1",
       "a2:c1",
       "a2:b3",
       "b2:c1",
       "b2:c2",
       "b1:c1",
       "b3:c3",
       "d1:e1",
       "c2:d1"]
    end
    it "build" do
      batches = normalize(graph.build)
      # ├── a1
      # │   ├── b1
      # │   │   └── c1
      # │   └── b2
      # │       ├── c1
      # │       └── c2
      # │           └── d1
      # │               └── e1
      # ├── a2
      # │   ├── c1
      # │   └── b3
      # │       └── c3
      # ├── a3
      # └── b4
      expect(batches).to eq(
        [
          ["a3", "b4", "c1", "c3", "e1"],
          ["b1", "b3", "d1"],
          ["a2", "c2"],
          ["b2"],
          ["a1"]
        ]
      )
    end
  end

  context "complex filter single node" do
    let(:stack_names) { ["a1", "b4", "a2", "b2", "e1", "b1", "b3", "a3", "c1", "c3", "d1", "c2"] }
    let(:dependencies) do
      ["a1:b1",
       "a1:b2",
       "a1:b1",
       "a2:c1",
       "a2:b3",
       "b2:c1",
       "b2:c2",
       "b1:c1",
       "b3:c3",
       "d1:e1",
       "c2:d1"]
    end
    let(:options) { {stacks: ["a2"] } }
    it "build" do
      batches = normalize(graph.build)
      # ├── a1
      # │   ├── b1
      # │   │   └── c1
      # │   └── b2
      # │       ├── c1
      # │       └── c2
      # │           └── d1
      # │               └── e1
      # ├── a2 <= only this part of tree used
      # │   ├── c1
      # │   └── b3
      # │       └── c3
      # ├── a3
      # └── b4
      expect(batches).to eq(
        [
          ["c1", "c3"],
          ["b3"],
          ["a2"],
        ]
      )
    end
  end

  context "complex filter multiple nodes" do
    let(:stack_names) { ["a1", "b4", "a2", "b2", "e1", "b1", "b3", "a3", "c1", "c3", "d1", "c2"] }
    let(:dependencies) do
      ["a1:b1",
       "a1:b2",
       "a1:b1",
       "a2:c1",
       "a2:b3",
       "b2:c1",
       "b2:c2",
       "b1:c1",
       "b3:c3",
       "d1:e1",
       "c2:d1"]
    end
    let(:options) { {stacks: ["b1", "a2"] } }
    it "build" do
      batches = normalize(graph.build)
      # ├── a1
      # │   ├── b1 <= this part of tree used
      # │   │   └── c1
      # │   └── b2
      # │       ├── c1
      # │       └── c2
      # │           └── d1
      # │               └── e1
      # ├── a2 <= this part of tree used
      # │   ├── c1
      # │   └── b3
      # │       └── c3
      # ├── a3
      # └── b4
      expect(batches).to eq(
        [
          ["c1", "c3"],
          ["b1", "b3"],
          ["a2"]
        ]
      )
    end
  end

  # Changes batches
  #    from: Array of Sets with Nodes
  #    to:   Array of Arrays with Strings
  def normalize(batches)
    batches.map(&:to_a).map do |batch|
      batch.map(&:name)
    end
  end
end
