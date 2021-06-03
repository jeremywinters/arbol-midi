require_relative 'builder_node.rb'
require_relative 'traversal_actions.rb'

module Arbol
  class BuilderRefNode < BuilderNode
    attr_accessor :identifier

    # @param [Object] parent
    # @param [String] identifier reference
    def initialize(parent, node_id, identifier)
      super(parent)
      @identifier = identifier
      @node_id = node_id
    end

    def create_symbols
      # creates all named symbols, including vector references
      super
      # will error out if reference doesn't exist
      get_symbol(identifier)
    end
    
    def resolve_static_flag
      @static = get_symbol(identifier)[:static]
    end
    
    def resolve_data
      # creates deduped constant value entries (that can be reused)
      # insures every object which needs a referencable data location has one
      # also reserves additional data space as required by objects
      super
      # mem_indx was resolved to identifier in the previous pass
      @mem_indx = get_symbol(identifier)[:mem_indx]
      puts("symbol: #{@identifier} references data location: #{@mem_indx}")
    end
    
    def create_parameters
      nil
    end
    
    def resolve
      {
        type: :ref,
        node_id: @node_id,
        identifier: @identifier,
        mem_indx: @mem_indx,
        parameter_indx: @parameter_indx,
        static: @static
      }
    end
  end
end
