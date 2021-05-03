require_relative 'builder_node.rb'
require_relative 'traversal_actions.rb'

module Arbol
  class BuilderVectorDefinitionNode < BuilderNode
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Ref
    include Arbol::TraversalActions::Openvectorref
    include Arbol::TraversalActions::Closevectordefinition

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
      create_symbol(@identifier, :vector)
      
      # vector length
      @additional_indx << get_constant_indx(@expressions.length)
      @mem_indx = get_data_indx(0)
      set_symbol_mem_indx(@identifier, @mem_indx)
    end
    
    def resolve_data
      # creates deduped constant value entries (that can be reused)
      # insures every object which needs a referencable data location has one
      # also reserves additional data space as required by objects
      super
    end

    def executable_instruction()
      @expressions.map { |e| e.executable_instruction() }
      # add_instruction(["INSTR_VECTOR_ASSIGN", @parameter_indx])
    end

    def create_parameters()
      params = []
      
      if @expressions
        @expressions.map { |e| e.create_parameters() }
        
        # vector specific handling to create param refs for every expression
        @expressions.each { |e| params << e.mem_indx }
      end

      @additional_indx.each { |i| params << i }
      
      if @mem_indx
        params << @mem_indx
      end
      
      params.each { |param| submit_parameter_indx(param) }
      @parameter_indx = get_parameter_indx()
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
