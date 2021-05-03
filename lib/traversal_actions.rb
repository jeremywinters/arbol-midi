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
    
    module Openvectorref
      # @param [Array] instruction
      def openvectorref(instruction)
        @expressions << Arbol::BuilderVectorRefNode.new(
          self,
          instruction[0],
          instruction[2]
        )
      end
    end

    # configured as module for mix-in
    module Closevectorref
      # @param [Array] instruction
      def closevectorref
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
end
