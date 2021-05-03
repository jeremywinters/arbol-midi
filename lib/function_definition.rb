require_relative 'builder_node.rb'
require_relative 'traversal_actions.rb'

module Arbol
  class BuilderFunctionDefinitionNode < BuilderNode
    include Arbol::TraversalActions::Opendef
    include Arbol::TraversalActions::Closedef
    include Arbol::TraversalActions::Identifier
    include Arbol::TraversalActions::Openfuncbody
    include Arbol::TraversalActions::Closefuncbody
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Ref

    attr_accessor :function_name
    attr_accessor :parameters

    # @param [Object] parent
    # @param [String] identifier name assigned to function
    def initialize(parent, node_id, identifier)
      super(parent)
      @function_name = identifier
      @parameters = []
      @node_id = node_id
    end

    def resolve
      {
        type: :def,
        node_id: @node_id,
        function_name: @function_name,
        parameters: @parameters,
        function_body: @expressions.map { |c| c.resolve }
      }
    end
  end
end
