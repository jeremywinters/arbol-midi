require_relative 'builder_node.rb'
require_relative 'traversal_actions.rb'

module Arbol
  class BuilderVectorRefNode < BuilderNode
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Ref
    include Arbol::TraversalActions::Openvectorref
    include Arbol::TraversalActions::Closevectorref

    attr_accessor :identifier
    attr_accessor :vector_length
    
    # @param [Object] parent
    # @param [String] identifier name associated with assignment
    def initialize(parent, node_id, identifier)
      super(parent)
      @identifier = identifier
      @node_id = node_id
    end
    
    def create_symbols
      # creates all named symbols, including vector references
      super
      validate_symbol = get_symbol(@identifier)
      unless(validate_symbol[:type] == :vector)
        raise("reference #{@identifier} is not a vector")
      end
    end
    
    def resolve_data
      # creates deduped constant value entries (that can be reused)
      # insures every object which needs a referencable data location has one
      # also reserves additional data space as required by objects
      @expressions.map { |a| a.resolve_data }
    end

    def executable_instruction()
      @expressions.map { |e| e.executable_instruction() }
      # add_instruction(["INSTR_VECTOR_ASSIGN", @parameter_indx])
    end

    def resolve
      {
        type: :vector,
        node_id: @node_id,
        identifier: @identifier,
        expressions: @expressions.map { |c| c.resolve },
        mem_indx: @mem_indx,
        parameter_indx: @parameter_indx
      }
    end
  end
end
