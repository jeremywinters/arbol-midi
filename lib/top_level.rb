require_relative 'builder_node.rb'
require_relative 'traversal_actions.rb'
require_relative 'action.rb'
require_relative 'assignment.rb'
require_relative 'function_definition.rb'
require_relative 'function.rb'
require_relative 'ref.rb'
require_relative 'vector_definition.rb'
require_relative 'vector_ref.rb'

module Arbol
  class BuilderTopLevelNode < BuilderNode
    include Arbol::TraversalActions::Openassign
    include Arbol::TraversalActions::Opendef
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Openaction
    include Arbol::TraversalActions::Openvectordefinition
    
    attr_accessor :data
    attr_accessor :symbols
    attr_accessor :assignments
    attr_accessor :definitions
    attr_accessor :strips
    attr_accessor :constants
    attr_accessor :references
    attr_accessor :vectors
    attr_accessor :parameters
    attr_accessor :instructions
    
    # @param [Object] parent
    def initialize(parent)
      super(parent)
      @executable = []
      @definitions = []
      @constants = {}
      @symbols = {}
      @data = []
      @references = {}
      @parameters = []
      @instructions = []
      @parameter_pointer = 0
      @current_object = self
    end
    
    # recursively executed steps
    def create_symbols
      @executable.map { |a| a.create_symbols }
    end
    
    def resolve_data
      @executable.map { |a| a.resolve_data }
    end
    
    def resolve_static_flag
      @executable.map { |a| a.resolve_static_flag }
    end
        
    def create_parameters()
      @executable.map { |e| e.create_parameters }
    end

    def validate_params()
      @executable.map { |e| e.validate_params() }
    end

    def executable_instruction()
      @executable.map { |e| e.executable_instruction() }
    end

    def resolve
      {
        assignments: @executable.map { |a| a.resolve },
        definitions: @definitions.map { |a| a.resolve }
      }
    end
  end
end
