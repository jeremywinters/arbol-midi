require 'pp'
require_relative 'parser.rb'

# top level namespace
module Arbol
  # these are instructions to be used as mix-ins... providing methods
  # to the builder classes without repeating their definitions
  module TraversalActions
    # configured as module for mix-in
    module Openassign
      # @param [Array] instruction
      def openassign(instruction)
        @executable << Arbol::BuilderAssignmentNode.new(
          self,
          instruction[0],
          instruction[2]
        )
        set_current_object(@executable.last)
      end
    end

    # configured as module for mix-in
    module Closeassign
      # @param [Array] instruction
      def closeassign(instruction)
        set_current_object(@parent)
      end
    end

    module Openvectordefinition
      # @param [Array] instruction
      def openvectordefinition(instruction)
        @executable << Arbol::BuilderVectorDefinitionNode.new(
          self,
          instruction[0],
          instruction[2]
        )
        set_current_object(@executable.last)
      end
    end

    # configured as module for mix-in
    module Closevectordefinition
      # @param [Array] instruction
      def closevectordefinition(instruction)
        set_current_object(@parent)
      end
    end
    
    module Openaction
      # @param [Array] instruction
      def openaction(instruction)
        @executable << Arbol::BuilderActionNode.new(
          self,
          instruction[0],
          instruction[2]
        )
        set_current_object(@executable.last)
      end
    end

    # configured as module for mix-in
    module Closeaction
      # @param [Array] instruction
      def closeaction(instruction)
        set_current_object(@parent)
      end
    end

    # configured as module for mix-in
    module Opendef
      # @param [Array] instruction
      def opendef(instruction)
        @definitions << Arbol::BuilderFunctionDefinitionNode.new(
          self,
          instruction[0],
          instruction[2]
        )
        set_current_object(@definitions.last)
      end
    end

    # configured as module for mix-in
    module Openfunc
      # @param [Array] instruction
      def openfunc(instruction)
        @expressions << Arbol::BuilderFunctionNode.new(
          self,
          instruction[0],
          instruction[2]
        )
        set_current_object(@expressions.last)
      end
    end

    # configured as module for mix-in
    module Closefunc
      # @param [Array] instruction
      def closefunc(instruction)
        set_current_object(@parent)
      end
    end

    # configured as module for mix-in
    module Openfuncbody
      # @param [Array] instruction
      def openfuncbody(instruction)
        nil
      end
    end

    # configured as module for mix-in
    module Closefuncbody
      # @param [Array] instruction
      def closefuncbody(instruction)
        nil
      end
    end

    # configured as module for mix-in
    module Closedef
      # @param [Array] instruction
      def closedef(instruction)
        set_current_object(@parent)
      end
    end

    # configured as module for mix-in
    module Identifier
      # @param [Array] instruction
      def identifier(instruction)
        @parameters << instruction[2]
      end
    end

    # configured as module for mix-in
    module Int
      # @param [Array] instruction
      def int(instruction)
        raise "value already set" if @value
        @value = instruction[2] unless @value
      end
    end

    # configured as module for mix-in
    module Float
      # @param [Array] instruction
      def float(instruction)
        raise "value already set" if @value
        @value = instruction[2]
      end
    end

    # configured as module for mix-in
    module Range
      # @param [Array] instruction
      def range(instruction)
        raise "instruction not implemented for class of type: #{self.class}"
      end
    end

    # configured as module for mix-in
    module Ref
      # @param [Array] instruction
      def ref(instruction)
        @expressions << Arbol::BuilderRefNode.new(
          self,
          instruction[0],
          instruction[2]
        )
      end
    end
  end

  # base class for all builder classes
  class BuilderNode
    # reference to parent object
    attr_accessor :parent

    # array of child expressions referring to this parent
    attr_accessor :expressions

    # reference to the current object being built
    attr_accessor :current_object

    # used by some objects to store a scalar value instead
    # of using an expression.
    attr_accessor :value

    # unique ID for this node
    attr_accessor :node_id

    attr_accessor :mem_indx
    attr_accessor :additional_indx
    
    # set parent object
    # @param [Object] parent
    def initialize(parent)
      @parent = parent
      @expressions = []
      @additional_indx = []
    end

    # returns a reference to the current object in the tree.
    def get_current_object
      if @current_object.nil?
        @parent.get_current_object
      else
        @current_object
      end
    end

    # sets the current object for this tree.
    # @param [Object] reference
    def set_current_object(reference)
      unless @current_object.nil?
        @current_object = reference
      else
        @parent.set_current_object(reference)
      end
    end

    # instruction is an array passed from the ast traversal process. each
    # instruction has a reference as the first element, indicating the action
    # that should be taken. this action is implemented through a method on the
    # current_object. note that not every action method is implemented on
    # every subclass of BuilderNode. actions are attached to BuilderNode
    # subclasses using include statements.
    # @param [Array] instruction
    def traversal_action(instruction)
      case
        when instruction[1] == :openassign then openassign(instruction)
        when instruction[1] == :closeassign then closeassign(instruction)
        
        when instruction[1] == :openvectordefinition then openvectordefinition(instruction)
        when instruction[1] == :closevectordefinition then closevectordefinition(instruction)
        
        when instruction[1] == :opendef then opendef(instruction)
        when instruction[1] == :openfuncbody then openfuncbody(instruction)
        when instruction[1] == :closefuncbody then closefuncbody(instruction)
        when instruction[1] == :closedef then closedef(instruction)

        when instruction[1] == :openfunc then openfunc(instruction)
        when instruction[1] == :closefunc then closefunc(instruction)

        when instruction[1] == :openaction then openaction(instruction)
        when instruction[1] == :closeaction then closeaction(instruction)

        when instruction[1] == :identifier then identifier(instruction)
        when instruction[1] == :int then int(instruction)
        when instruction[1] == :float then float(instruction)
        when instruction[1] == :range then range(instruction)
        when instruction[1] == :ref then ref(instruction)
      end
    end

    # needs to be implemented in subclass
    def resolve
      raise "resolve undefined for class: #{self.class}"
    end

    def resolve_constants
      raise "resolve_constants undefined for class: #{self.class}"
    end

    def resolve_references
      raise "resolve_references undefined for class: #{self.class}"
    end
    
    def validate_params
      puts("inside validate_params")
      puts(self.class)
      puts(@expressions)
      @expressions.each { |e| e.validate_params() }
    end

    # return the index of this constant
    def get_constant_indx(constant_value)
      if @constants
        # this subclass handles constants
        @constants << constant_value.to_f
        return @constants.length - 1
      else
        # otherwise check the parent
        return @parent.get_constant_indx(constant_value)
      end
    end

    def create_reference(reference_name)
      if @references
        if @references.has_key?(reference_name)
          raise "reference #{reference_name} already exists"
        end
        @references[reference_name] = get_constant_indx(0)
      else
        @parent.create_reference(reference_name)
      end
    end

    def get_reference_indx(reference_name)
      if @references
        if @references.has_key?(reference_name)
          return @references[reference_name]
        else
          raise "reference #{reference_name} not defined!"
        end
      else
        return @parent.get_reference_indx(reference_name)
      end
    end
    
    def create_parameters() 
      return nil if @function_type == 'const'
      
      params = []
      if @expressions
        @expressions.map { |e| e.create_parameters() }
        @expressions.each { |e| params << e.mem_indx }
      end

      @additional_indx.each { |i| params << i }
      
      if @mem_indx
        params << @mem_indx
      end
      
      params.each { |param| submit_parameter_indx(param) }
      @parameter_indx = get_parameter_indx()
    end

    def submit_parameter_indx(indx)
      if @parameters
        @parameters << indx
      else
        @parent.submit_parameter_indx(indx)
      end
    end

    def get_parameter_indx()
      if @parameters
        return @parameters.length - 1
      else
        @parent.get_parameter_indx()
      end
    end
    
    def add_vector(vector_name)
      if @vectors
        unless @vectors.keys.include?(vector_name)
          vectors[vector_name] = {size: 0, param_indx: 0}
        else
          raise "vector #{vector_name} already defined"
        end
      else
        @parent.add_vector(vector_name)
      end
    end

    def function_to_instruction(function_name)
      return {
        "add" => {instr: "INSTR_ADD", param_count: 2},
        "subtract" => {instr: "INSTR_SUBTRACT", param_count: 2},
        "mult" => {instr: "INSTR_MULTIPLY", param_count: 2},
        "divide" => {instr: "INSTR_DIVIDE", param_count: 2},
        "modulo" => {instr: "INSTR_MODULO", param_count: 2},

        "equals" => {instr: "INSTR_EQUALS", param_count: 2},
        "ne" => {instr: "INSTR_NE", param_count: 2},
        "gt" => {instr: "INSTR_GT", param_count: 2},
        "gtequals" => {instr: "INSTR_GTEQUALS", param_count: 2},
        "lt" => {instr: "INSTR_LT", param_count: 2},
        "ltequals" => {instr: "INSTR_LTEQUALS", param_count: 2},     
        
        "pow" => {instr: "INSTR_POW", param_count: 2},
        "sin" => {instr: "INSTR_SIN", param_count: 1},
        "cos" => {instr: "INSTR_COS", param_count: 1},
        "tan" => {instr: "INSTR_TAN", param_count: 1},
        "atan" => {instr: "INSTR_ATAN", param_count: 1},
        
        "sqrt" => {instr: "INSTR_SQRT", param_count: 1},
        
        "abs" => {instr: "INSTR_ABS", param_count: 1},
        "exp" => {instr: "INSTR_EXP", param_count: 1},
        "log" => {instr: "INSTR_LOG", param_count: 1},
        "log10" => {instr: "INSTR_LOG10", param_count: 1},
        "round" => {instr: "INSTR_ROUND", param_count: 1},

        "phasor" => {instr: "INSTR_PHASOR", param_count: 1},
        "midi_cc" => {instr: "INSTR_MIDI_CC", param_count: 3},
        "square" => {instr: "INSTR_SQUARE", param_count: 2},
        
        "millis" => {instr: "INSTR_MILLIS", param_count: 0},
        "micros" => {instr: "INSTR_MICROS", param_count: 0},
        "pi" => {instr: "INSTR_PI", param_count: 0},
        "twopi" => {instr: "INSTR_TWOPI", param_count: 0},
        
        "choose" => {instr: "INSTR_CHOOSE", param_count: 3},
        "between" => {instr: "INSTR_BETWEEN", param_count: 3},
        
        "ez_sin" => {instr: "INSTR_EZSIN", param_count: 1},
        "ez_cos" => {instr: "INSTR_EZCOS", param_count: 1},

        "random" => {instr: "INSTR_RANDOM", param_count: 0},
        "sah" => {instr: "INSTR_SAH", param_count: 2},
        "constrain" => {instr: "INSTR_CONSTRAIN", param_count: 3},
        "edge" => {instr: "INSTR_EDGE", param_count: 2},
        "feedback" => {instr: "INSTR_FEEDBACK", param_count: 2},
        "midi_note" => {instr: "INSTR_MIDI_NOTE", param_count: 4}
      }[function_name]
    end

    def executable_instruction()
      @expressions.map { |e| e.executable_instruction() }
    end

    def add_instruction(instruction)
      if @instructions
        @instructions << instruction
      else
        @parent.add_instruction(instruction)
      end
    end

  end

  class BuilderTopLevelNode < BuilderNode
    include Arbol::TraversalActions::Openassign
    include Arbol::TraversalActions::Opendef
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Openaction
    include Arbol::TraversalActions::Openvectordefinition
    
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
      @constants = []
      @references = {}
      @parameters = []
      @instructions = []
      @vectors = {}
      @parameter_pointer = 0
      @current_object = self
    end

    def resolve_constants
      @executable.map { |a| a.resolve_constants }
    end

    def resolve_references
      @executable.map { |a| a.resolve_references }
    end

    def create_parameters()
      @executable.map { |e| e.create_parameters() }
    end

#     def set_parameter_indx()
#       @executable.map { |e| e.set_parameter_indx() }
#     end

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

  class BuilderAssignmentNode < BuilderNode
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Ref
    include Arbol::TraversalActions::Closeassign

    attr_accessor :identifier

    # @param [Object] parent
    # @param [String] identifier name associated with assignment
    def initialize(parent, node_id, identifier)
      super(parent)
      @identifier = identifier
      @node_id = node_id
    end

    def resolve_constants
      @expressions.map { |a| a.resolve_constants }
      create_reference(@identifier)
      @mem_indx = get_reference_indx(@identifier)
    end

    def resolve_references
      @expressions.map { |a| a.resolve_references }
      create_reference(@identifier)
      @mem_indx = get_reference_indx(@identifier)
    end

    def executable_instruction()
      @expressions.map { |e| e.executable_instruction() }
      add_instruction(["INSTR_ASSIGN", @parameter_indx])
    end

    def resolve
      {
        type: :assignment,
        node_id: @node_id,
        identifier: @identifier,
        expressions: @expressions.map { |c| c.resolve },
        mem_indx: @mem_indx,
        parameter_indx: @parameter_indx
      }
    end
  end

  class BuilderVectorDefinitionNode < BuilderNode
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Ref
    include Arbol::TraversalActions::Closeassign

    attr_accessor :identifier
    attr_accessor :vector_length
    
    # @param [Object] parent
    # @param [String] identifier name associated with assignment
    def initialize(parent, node_id, identifier)
      super(parent)
      @identifier = identifier
      @node_id = node_id
    end

    def resolve_constants
      @expressions.map { |a| a.resolve_constants }
      @additional_indx << get_constant_indx(@expressions.length.to_f)
    end

    def resolve_references
      @expressions.map { |a| a.resolve_references }
    end

    def executable_instruction()
      @expressions.map { |e| e.executable_instruction() }
      add_instruction(["INSTR_VECTOR_ASSIGN", @parameter_indx])
    end

    def create_parameters()
      params = []
      
      if @expressions
        @expressions.map { |e| e.create_parameters() }
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
  
  class BuilderActionNode < BuilderNode
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Ref
    include Arbol::TraversalActions::Closeaction

    attr_accessor :identifier

    # @param [Object] parent
    # @param [String] identifier name associated with assignment
    def initialize(parent, node_id, identifier)
      super(parent)
      @identifier = identifier
      @node_id = node_id
    end

    def resolve_constants
      @expressions.map { |a| a.resolve_constants }
      
      # extra memory for previous midi note
      if ['midi_note'].include?(@identifier)
        3.times { @additional_indx << get_constant_indx(0.0) }
      end
      @mem_indx = get_constant_indx(0.0)
    end

    def resolve_references
      @expressions.map { |a| a.resolve_references }
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

  class BuilderFunctionNode < BuilderNode
    include Arbol::TraversalActions::Openfunc
    include Arbol::TraversalActions::Closefunc
    include Arbol::TraversalActions::Int
    include Arbol::TraversalActions::Float
    include Arbol::TraversalActions::Ref

    attr_accessor :function_type

    # @param [Object] parent
    # @param [String] identifier function type
    def initialize(parent, node_id, identifier)
      super(parent)
      @function_type = identifier
      @node_id = node_id
    end

    def executable_instruction()
      @expressions.map { |e| e.executable_instruction() }
      if ['const'].include?(@function_type)
        nil
      else
        add_instruction([function_to_instruction(@function_type)[:instr], @parameter_indx])
      end
    end
    
    def functions_types_with_additional_indx
      ['sah', 'edge', 'feedback']
    end
    
    def resolve_constants
      @expressions.map { |a| a.resolve_constants }
      if ['const'].include?(@function_type)
        @mem_indx = get_constant_indx(value)
      else
        if functions_types_with_additional_indx.include?(@function_type)
          @additional_indx << get_constant_indx(0.0)
        end
        @mem_indx = get_constant_indx(0.0)
      end
    end

    def resolve_references
      @expressions.map { |a| a.resolve_references }
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

  class BuilderRefNode < BuilderNode
    attr_accessor :identifier

    # @param [Object] parent
    # @param [String] identifier reference
    def initialize(parent, node_id, identifier)
      super(parent)
      @identifier = identifier
      @node_id = node_id
    end

    def resolve_constants
      @mem_indx = get_reference_indx(@identifier)
    end

    def resolve_references
      @mem_indx = get_reference_indx(@identifier)
    end

    def resolve
      {
        type: :ref,
        node_id: @node_id,
        identifier: @identifier,
        mem_indx: @mem_indx,
        parameter_indx: @parameter_indx
      }
    end
  end

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

# b.tree.resolve_references()
b.tree.validate_params()
b.tree.resolve_constants()
b.tree.create_parameters()
b.tree.executable_instruction()
# b.tree.set_parameter_indx()

pp(b.tree.resolve, width = 4)
b.tree.constants.each_with_index { |e, i| puts("symbols[#{i}] = #{e};") }
b.tree.parameters.each_with_index { |e, i| puts("params[#{i}] = #{e};") }
b.tree.instructions.each_with_index do |e, i|
  puts("instruction[#{i}][0]=#{e[0]}; instruction[#{i}][1]=#{e[1]};")
end
puts("num_instructions = #{b.tree.instructions.length};")

#t = Arbol::BuilderTopLevelNode.new(b.tree.resolve)

#pp(t.resolve)
