require_relative 'builder_node.rb'
require_relative 'traversal_actions.rb'

module Arbol
  class BuilderAssignmentNode < BuilderNode
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Ref
    include Arbol::TraversalActions::Openvectorref
    include Arbol::TraversalActions::Closeassign

    attr_accessor :identifier

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
      create_symbol(@identifier, :variable)
    end
    
    def resolve_data
      # creates deduped constant value entries (that can be reused)
      # insures every object which needs a referencable data location has one
      # also reserves additional data space as required by objects
      super
      puts("symbol mem_indx: #{}")
      set_symbol_mem_indx(@identifier, @expressions.first.mem_indx)
    end
    
    def create_parameters
      @expressions.each { |e| e.create_parameters }
    end
    
    def resolve_static_flag
      super
      set_symbol_static(@identifier, @expressions.first.static)
    end

    def executable_instruction()
      @expressions.map { |e| e.executable_instruction() }
      # add_instruction(["INSTR_ASSIGN", @parameter_indx])
    end

    def resolve
      {
        type: :assignment,
        node_id: @node_id,
        identifier: @identifier,
        expressions: @expressions.map { |c| c.resolve },
        mem_indx: @mem_indx,
        parameter_indx: @parameter_indx,
        static: @static
      }
    end
  end
end
