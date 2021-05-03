require_relative 'builder_node.rb'
require_relative 'traversal_actions.rb'

module Arbol
  class BuilderFunctionNode < BuilderNode
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Closefunc
    include Arbol::TraversalActions::Int
    include Arbol::TraversalActions::Float
    include Arbol::TraversalActions::Ref
    include Arbol::TraversalActions::Openvectorref
    
    attr_accessor :function_type

    # @param [Object] parent
    # @param [String] identifier function type
    def initialize(parent, node_id, identifier)
      super(parent)
      @function_type = identifier
      @node_id = node_id
    end
    
    def create_symbols
      # creates all named symbols, including vector references
      super
    end
    
    def resolve_data
      # creates deduped constant value entries (that can be reused)
      # insures every object which needs a referencable data location has one
      # also reserves additional data space as required by objects
      super
      
      if ['const'].include?(@function_type)
        @mem_indx = get_constant_indx(value)
      else
        if functions_types_with_additional_indx.include?(@function_type)
          @additional_indx << get_data_indx(0.0)
        end
        @mem_indx = get_data_indx(0.0)
      end
    end

    def executable_instruction
      @expressions.map { |e| e.executable_instruction }
      if ['const'].include?(@function_type)
        nil
      else
        add_instruction([function_to_instruction(@function_type)[:instr], @parameter_indx])
      end
    end
    
    def functions_types_with_additional_indx
      ['sah', 'edge', 'feedback']
    end
    
    def validate_params()
      if @function_type != 'const'
        @expressions.map { |e| e.validate_params() }
        params_provided = @expressions.length
        params_required = function_to_instruction(@function_type)[:param_count]
        if (params_provided != params_required)
          raise "function #{@function_type} requires #{params_provided} parameters but only #{params_provided} parameters found!"
        end
      end
    end

    def resolve
      {
        type: :function_reference,
        node_id: @node_id,
        function: @function_type,
        expressions: @expressions.map { |c| c.resolve },
        value: @value,
        mem_indx: @mem_indx,
        parameter_indx: @parameter_indx
      }
    end
  end
end
