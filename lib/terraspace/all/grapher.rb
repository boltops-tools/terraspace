require "graph"
require "tty-tree"

module Terraspace::All
  class Grapher < Base
    include Terraspace::Compiler::DirsConcern
    include Terraspace::Util::Logging

    def run
      check_graphviz!
      logger.info "Building graph..."
      graph = build_graph
      if @options[:format] == "text"
        text(graph.top_nodes)
      elsif @options[:format] == "json"
        puts (graph.build.map do |batch|
          batch.map { |stack| stack.name }
        end).to_json
      else
        draw(graph.nodes)
      end
    end

    def build_graph
      resolver = Terraspace::Dependency::Resolver.new(@options.merge(quiet: true, draw_full_graph: draw_full_graph))
      resolver.resolve
      dependencies = Terraspace::Dependency::Registry.data # populated after build_unresolved
      graph = Terraspace::Dependency::Graph.new(stack_names, dependencies, @options)
      graph.build
      graph
    end

    def text(nodes)
      Rainbow.enabled = false unless @options[:full]
      data = build_tree_data(nodes)
      Rainbow.enabled = true unless @options[:full]
      tree = TTY::Tree.new(data)
      logger.info tree.render
    end

    def build_tree_data(nodes)
      if nodes.size == 1
        tree_data(nodes.first)
      else
        root = Terraspace::Dependency::Node.new('.')
        nodes.each { |node| node.parent!(root) }
        tree_data(root)
      end
    end

    def tree_data(parent, data={})
      parent_name = text_name(parent)
      data[parent_name] ||= []
      parent.children.each do |child|
        child_name = text_name(child)
        if child.children.empty? # leaf node
          data[parent_name] << child_name
        else
          next_data = { child_name => [] }
          data[parent_name] << tree_data(child, next_data)
        end
      end
      data
    end

    def text_name(node)
      node.highlighted? ? node.name.bright : node.name
    end

    def draw(nodes)
      path, filename = nil, filename() # outside block to capture value
      digraph do
        node_attribs << color('"#b6d7a8"') << filled << fontcolor("white")
        edge_attribs << color('"#999999"') << filled
        nodes.each do |parent|
          if parent.highlighted?
            node(parent.name)
          else
            node(parent.name).attributes << color('"#A4C2F4"')
          end
          parent.children.each do |child|
            edge(parent.name, child.name)
          end
        end
        FileUtils.mkdir_p(File.dirname(filename))
        save(filename, "png")
        path = "#{filename}.png"
      end

      logger.info "Graph saved to #{Terraspace::Util.pretty_path(path)}"
      open(path)
    end

  private
    def draw_full_graph
      if @options[:format] == "text"
        @options[:full].nil? ? false : @options[:full]
      else
        @options[:full].nil? ? true : @options[:full]
      end
    end


    def filename
      name = "#{Terraspace.cache_root}/graph/dependencies" # dont include extension
      unless ENV['TS_GRAPH_TS'] == '0'
        @@timestamp ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
        name += "-#{@@timestamp}"
      end
      name
    end

    def open(path)
      command = command("c9") || command("open")
      system("#{command} #{path}") if command
    end

    def command(name)
      name if system("type #{name} > /dev/null 2>&1") # c9 = cloud9, open = macosx
    end

    # Check if Graphiz is installed and prints a user friendly message if it is not installed.
    def check_graphviz!
      return if ['text', 'json'].include?(@options[:format])

      installed = system("type dot > /dev/null 2>&1") # dot is a command that is part of the graphviz package
      return if installed
      logger.error "ERROR: It appears that the Graphviz is not installed.  Please install it to use the graph command.".color(:red)
      install_instructions
      logger.info <<~EOL
        Also consider:

            terraspace all graph --format text

        Which will print out the graph in text form.
      EOL
      exit 1
    end

    def install_instructions
      installer = if RUBY_PLATFORM =~ /darwin/
        "brew"
      elsif system("type yum > /dev/null 2>&1")
        "yum"
      elsif system("type apt-get > /dev/null 2>&1")
        "apt-get"
      end

      return unless installer
      logger.error <<~EOL
        You can install Graphviz with:

            #{installer} install graphviz

      EOL
    end
  end
end
