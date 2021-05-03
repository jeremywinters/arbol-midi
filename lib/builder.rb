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
b.tree.create_parameters()
b.tree.executable_instruction()

pp(b.tree.resolve, width = 4)
b.tree.data.each_with_index { |e, i| puts("symbols[#{i}] = #{e};") }
b.tree.parameters.each_with_index { |e, i| puts("params[#{i}] = #{e};") }
b.tree.instructions.each_with_index do |e, i|
  puts("instruction[#{i}][0]=#{e[0]}; instruction[#{i}][1]=#{e[1]};")
end
puts("num_instructions = #{b.tree.instructions.length};")

#t = Arbol::BuilderTopLevelNode.new(b.tree.resolve)

#pp(t.resolve)
