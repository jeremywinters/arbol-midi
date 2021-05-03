require_relative 'builder_node.rb'
require_relative 'traversal_actions.rb'

module Arbol  
  class BuilderActionNode < BuilderNode
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Ref
    include Arbol::TraversalActions::Openvectorref
    include Arbol::TraversalActions::Closeaction

    attr_accessor :identifier

    # @param [Object] parent
    # @param [String] identifier name associated with assignment
    def initialize(parent, node_id, identifier)
      super(parent)
      @identifier = identifier
      @node_id = node_id
    end

    def create_symbols
      super
    end
    
    def resolve_data
      # creates deduped constant value entries (that can be reused)
      # insures every object which needs a referencable data location has one
      # also reserves additional data space as required by objects
      super
      
      # extra memory for previous midi note
      if ['midi_note'].include?(@identifier)
        3.times { @additional_indx << get_data_indx(0.0) }
      end
      @mem_indx = get_data_indx(0.0)
    end

    def executable_instruction()
      @expressions.map { |e| e.executable_instruction() }
      add_instruction([function_to_instruction(@identifier)[:instr], @parameter_indx])
    end

    def resolve
      {
        type: :action,
        node_id: @node_id,
        identifier: @identifier,
        expressions: @expressions.map { |c| c.resolve },
        mem_indx: @mem_indx,
        parameter_indx: @parameter_indx
      }
    end
  end
end
