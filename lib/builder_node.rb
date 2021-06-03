# top level namespace
module Arbol
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
    
    # array of additional indices required
    attr_accessor :additional_indx
    
    # whether or not this object is single execution only
    attr_accessor :static
    
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

        when instruction[1] == :openvectorref then openvectorref(instruction)
        when instruction[1] == :closevectorref then closevectorref(instruction)
            
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
    
    def create_symbols
      # creates all named symbols, including vector references
      @expressions.map { |a| a.create_symbols }
      puts(self.class)
    end
    
    def resolve_data
      # creates deduped constant value entries (that can be reused)
      # insures every object which needs a referencable data location has one
      # also reserves additional data space as required by objects
      @expressions.map { |a| a.resolve_data }
    end

    def resolve_static_flag
      @expressions.each { |e| e.resolve_static_flag }
      flags = @expressions.map { |e| e.static} || []
      if flags.include?(false)
        @static = false
      else
        @static = true
      end
    end
    
    def static_as_int
      return (@static == true) ? 1 : 0
    end

    # provisions a data indx with a default value
    # returns the indx
    def get_data_indx(constant_value)
      if @data
        # this subclass handles data
        @data << constant_value.to_f # add a 0 to the list
        return @data.length - 1 # return it's position
      else
        # otherwise check the parent
        return @parent.get_data_indx(constant_value)
      end
    end

    def get_constant_indx(constant_value)
      if @data
        # this subclass handles constants
        unless(@constants.keys.include?(constant_value))
          # new constant, create before returning indx
          @constants[constant_value] = get_data_indx(constant_value)
        end
        return @constants[constant_value]
      else
        # otherwise check the parent
        return @parent.get_constant_indx(constant_value)
      end
    end
    
    
    # symbol management
    
    def create_symbol(identifier, type)
      puts('create_symbol')
      puts(identifier)
      puts(type)
      puts(@parent.class)
      if(@symbols)
        # this object handles symbols
        if(@symbols.keys.include?(identifier))
          raise "symbol #{identifier} can not be defined twice!"
        else
          @symbols[identifier] = { type: type }
        end
      else
        @parent.create_symbol(identifier, type)
      end
    end
    
    def get_symbol(identifier)
      if(@symbols)
        if(@symbols[identifier])
          return @symbols[identifier]
        else
          raise "symbol #{identifier} must be defined before referencing"
        end
      else
        @parent.get_symbol(identifier)
      end
    end
    
    def set_symbol_mem_indx(identifier, data_indx)
      if(@symbols)
        symbols[identifier][:mem_indx] = data_indx
      else
        @parent.set_symbol_mem_indx(identifier, data_indx)
      end
    end
    
    def set_symbol_static(identifier, static_flag)
      if(@symbols)
        symbols[identifier][:static] = static_flag
      else
        @parent.set_symbol_static(identifier, static_flag)
      end
    end   

    def validate_params
      puts("inside validate_params")
      puts(self.class)
      puts(@expressions)
      @expressions.each { |e| e.validate_params() }
    end
    
    def create_parameters 
      puts("create parameters #{self.class}")
      return nil if @function_type == 'const'
      
      params = []
      if @expressions
        @expressions.each { |e| e.create_parameters }
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

    def get_parameter_indx
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
        "add" => {instr: "INSTR_ADD", param_count: 2, volatile: false},
        "subtract" => {instr: "INSTR_SUBTRACT", param_count: 2, volatile: false},
        "mult" => {instr: "INSTR_MULTIPLY", param_count: 2, volatile: false},
        "divide" => {instr: "INSTR_DIVIDE", param_count: 2, volatile: false},
        "modulo" => {instr: "INSTR_MODULO", param_count: 2, volatile: false},

        "equals" => {instr: "INSTR_EQUALS", param_count: 2, volatile: false},
        "ne" => {instr: "INSTR_NE", param_count: 2, volatile: false},
        "gt" => {instr: "INSTR_GT", param_count: 2, volatile: false},
        "gtequals" => {instr: "INSTR_GTEQUALS", param_count: 2, volatile: false},
        "lt" => {instr: "INSTR_LT", param_count: 2, volatile: false},
        "ltequals" => {instr: "INSTR_LTEQUALS", param_count: 2, volatile: false},     
        
        "pow" => {instr: "INSTR_POW", param_count: 2, volatile: false},
        "sin" => {instr: "INSTR_SIN", param_count: 1, volatile: false},
        "cos" => {instr: "INSTR_COS", param_count: 1, volatile: false},
        "tan" => {instr: "INSTR_TAN", param_count: 1, volatile: false},
        "atan" => {instr: "INSTR_ATAN", param_count: 1, volatile: false},
        
        "sqrt" => {instr: "INSTR_SQRT", param_count: 1, volatile: false},
        
        "abs" => {instr: "INSTR_ABS", param_count: 1, volatile: false},
        "exp" => {instr: "INSTR_EXP", param_count: 1, volatile: false},
        "log" => {instr: "INSTR_LOG", param_count: 1, volatile: false},
        "log10" => {instr: "INSTR_LOG10", param_count: 1, volatile: false},
        "round" => {instr: "INSTR_ROUND", param_count: 1, volatile: false},

        "phasor" => {instr: "INSTR_PHASOR", param_count: 1, volatile: true},
        "midi_cc" => {instr: "INSTR_MIDI_CC", param_count: 3, volatile: true},
        "square" => {instr: "INSTR_SQUARE", param_count: 2, volatile: true},
        
        "millis" => {instr: "INSTR_MILLIS", param_count: 0, volatile: true},
        "micros" => {instr: "INSTR_MICROS", param_count: 0, volatile: true},
        "pi" => {instr: "INSTR_PI", param_count: 0, volatile: false},
        "twopi" => {instr: "INSTR_TWOPI", param_count: 0, volatile: false},
        
        "choose" => {instr: "INSTR_CHOOSE", param_count: 3, volatile: false},
        "between" => {instr: "INSTR_BETWEEN", param_count: 3, volatile: false},
        
        "ez_sin" => {instr: "INSTR_EZSIN", param_count: 1, volatile: false},
        "ez_cos" => {instr: "INSTR_EZCOS", param_count: 1, volatile: false},

        "random" => {instr: "INSTR_RANDOM", param_count: 0, volatile: true},
        "sah" => {instr: "INSTR_SAH", param_count: 2, volatile: false},
        "constrain" => {instr: "INSTR_CONSTRAIN", param_count: 3, volatile: false},
        "edge" => {instr: "INSTR_EDGE", param_count: 2, volatile: true},
        "feedback" => {instr: "INSTR_FEEDBACK", param_count: 2, volatile: true},
        "midi_note" => {instr: "INSTR_MIDI_NOTE", param_count: 4, volatile: true},
        "input" => {instr: "INSTR_INPUT", param_count: 1, volatile: true},
        "fancy_phasor" => {instr: "INSTR_FANCY_PHASOR", param_count: 2, volatile: true},
        "flip_flop" => {instr: "INSTR_FLIP_FLOP", param_count: 2, volatile: true}
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
end
