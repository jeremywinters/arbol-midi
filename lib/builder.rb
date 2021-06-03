require_relative 'top_level.rb'
require_relative 'parser.rb'
require 'pp'

module Arbol
  class Builder
    attr_accessor :tree

    # create builder
    def initialize
      @tree = BuilderTopLevelNode.new(nil)
    end

    # builds an object tree using instructions returned from
    # ast traversal.
    # @param [Array<Array>] traversal
    def build(traversal)
      traversal.each do |i|
        pp(@tree.current_object.class)
        pp(i)
        @tree.current_object.traversal_action(i)
      end
    end
  end
end

b = Arbol::Builder.new

b.build(
  Arbol::Traverser.new.traverse(
    Arbol::Traverser.new.parse(
      File.read(ARGV[0])
    )
  )
)

b.tree.create_symbols
b.tree.resolve_data
b.tree.create_parameters
b.tree.resolve_static_flag
b.tree.executable_instruction

pp(b.tree.resolve)
pp(b.tree.symbols)

f = File.open('arbol_tmp.rb', 'w')

f.puts("void load_program() {")
b.tree.data.each_with_index { |e, i| f.puts("symbols[#{i}] = #{e};") }
b.tree.parameters.each_with_index { |e, i| f.puts("params[#{i}] = #{e};") }
b.tree.instructions.each_with_index do |e, i|
  f.puts("instruction[#{i}][0]=#{e[0]}; instruction[#{i}][1]=#{e[1]}; instruction[#{i}][2]=#{e[2]};")
end
f.puts("num_instructions = #{b.tree.instructions.length};")
f.puts("}")

#t = Arbol::BuilderTopLevelNode.new(b.tree.resolve)

#pp(t.resolve)
