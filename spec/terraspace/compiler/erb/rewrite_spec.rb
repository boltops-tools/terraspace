describe Terraspace::Compiler::Erb::Rewrite do
  let(:rewrite) { described_class.new(src_path) }

  context "has output" do
    let(:src_path) { fixture("rewrite/dev.tfvars") }
    it "replace" do
      input =<<~EOL
        length = <%= output('b1.length') %>
        foo = <%= foo %>
        <% depends_on "b1" %>
        <%
        3.times do |i|
          puts i
        end
        %>
      EOL
      text = rewrite.replace(input)
      expect(text).to eq <<~EOL
        length = <%= output('b1.length') %>
        foo = <%#= foo %>
        <% depends_on "b1" %>
        <%#
        3.times do |i|
          puts i
        end
        %>
      EOL
    end
  end
end
