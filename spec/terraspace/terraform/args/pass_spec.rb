describe Terraspace::Terraform::Args::Pass do
  let(:pass) do
    described_class.new(mod, name, options)
  end
  let(:mod) { double(:mod).as_null_object }
  let(:options) { {args: args} }
  # defaults
  let(:name) { "plan" }
  let(:args) { [] }

  context "boolean flag" do
    let(:args) { ["-refresh-only"] }
    it "pass through args" do
      args = pass.args
      expect(args).to eq ["-refresh-only"]
    end
  end

  context "assignment arg" do
    context "-refresh=false" do
      let(:args) { ["-refresh=false"] }
      it "pass through args" do
        args = pass.args
        expect(args).to eq ["-refresh=false"]
      end
    end

    context "-lock-timeout=5s" do
      let(:args) { ["-lock-timeout=5s"] }
      it "pass through args" do
        args = pass.args
        expect(args).to eq ["-lock-timeout=5s"]
      end
    end

    context "-var-file=filename -lock-timeout=5s" do
      let(:args) { ["-var-file=filename', '-lock-timeout=5s"] }
      it "pass through args" do
        args = pass.args
        expect(args).to eq ["-var-file=filename', '-lock-timeout=5s"]
      end
    end

    # normalizes -- to -
    context "--var-file=filename --lock-timeout=5s" do
      let(:args) { ["--var-file=filename", "--lock-timeout=5s"] }
      it "pass through args" do
        args = pass.args
        expect(args).to eq ["-var-file=filename", "-lock-timeout=5s"]
      end
    end
  end

  context "indirectly documented args" do
    # "terraform apply -help" doesn't document "-target" directly, but refers to
    # "terraform plan -help" documentation.
    context "-target=resource" do
      let(:args) { ["-target=foo.bar"] }
      let(:name) { "apply" }
      it "pass through args" do
        args = pass.args
        expect(args).to eq ["-target=foo.bar"]
      end
    end
  end

  context "hash arg" do
    context "-var 'foo=bar'" do
      let(:args) { ["-var 'foo=bar'"] }
      it "pass through args" do
        args = pass.args
        expect(args).to eq ["-var 'foo=bar'"]
      end
    end

    context "['-var', 'foo=bar'] improperly passed due to Thor CLI parsing" do
      let(:args) { ["-var", "foo=bar"] }
      it "reconstruct to work with terraform cli" do
        args = pass.send(:pass_args)
        expect(args).to eq ["var 'foo=bar'"]
      end
    end
  end

  # Works at the parsing level. Also works at Thor CLI parsing level. To test:
  #
  #     terraspace plan demo -refresh=false -no-color -var 'foo=bar' -var 'foo2=bar2'
  #
  # Results in:
  #
  #     terraform plan -input=false -refresh=false -no-color -var 'foo=bar' -var 'foo2=bar2'
  #
  context "multiple hash arg" do
    context "-var 'foo=bar' -var 'foo2=bar2'" do
      let(:args) { ["-var 'foo=bar'", "-var 'foo2=bar2'"] }
      it "pass through args" do
        args = pass.args
        expect(args).to eq ["-var 'foo=bar'", "-var 'foo2=bar2'"]
      end
    end
  end

  # Could mock out Pass#terraform_help with fixtures,
  # but will call out to terraform in specs so to see breakage more quickly.
  context "terraform_arg_types" do
    it "parses help output to determine arg types" do
      args = pass.send(:terraform_arg_types)
      # checking specific keys so spec is more robust to terraform cli changes
      expect(args['destroy']).to eq(:boolean)
      expect(args['refresh']).to eq(:assignment)
      expect(args['var']).to eq(:hash)
    end
  end
end
