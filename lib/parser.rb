require 'rltk/lexer'
require 'rltk/parser'
require 'rltk/ast'
require 'securerandom'

module Arbol
  # lexer to create array of tokens
  class Lexer < RLTK::Lexer
    # keywords
    rule(/return/) { |s| :RETURN }
    rule(/def/) { |s| :DEF }

    # operators and separators
    rule(/\(/) { :LPAREN }
    rule(/\)/) { :RPAREN }
    rule(/\[/) { :LBRACKET }
    rule(/\]/) { :RBRACKET }
    rule(/,/)  { :COMMA }
    rule(/\=/) { :ASSIGN }
    rule(/\;/) { :SEMICOLON }
    rule(/\+/) { :PLUS }
    rule(/\-/) { :MINUS }
    rule(/\*/) { :MULT }
    rule(/\//) { :DIVIDE }
    rule(/\%/) { :MODULO }
    rule(/\={2}/) { :EQUALS }
    rule(/\!\=/) { :NE }
    rule(/\>\=/) { :GTEQUALS }
    rule(/\>/) { :GT }
    rule(/\<\=/) { :LTEQUALS }
    rule(/\</) { :LT }

    # identifiers
    rule(/[a-zA-Z]+[a-zA-Z0-9\_]*/) { |i| [:IDENT, i] }

    # range
    rule(/\d+\.\.\d+/) { |r| [:RANGE, r] }

    # constants
    rule(/\d+/) { |t| [:INTEGER, t.to_i] }
    rule(/\d+\.+\d*/) { |t| [:FLOAT, t.to_f] }
    rule(/\d*\.+\d+/) { |t| [:FLOAT, t.to_f] }

    # whitespace
    rule(/\s/)

    # comments
  	rule(/#/)	{ push_state :comment }
  	rule(/\n/, :comment) { pop_state }
  	rule(/./, :comment)
  end

  # An Expression class is inherited from RLTK::ASTNode, which
  # represents the internal parser results.
  class Expression < RLTK::ASTNode; end

  # An Variable class that contains array-typed expression
  class Variable < Expression
    value :name, Array
  end

  # A OneExp class that contains one-child ast
  class OneExp < Expression
    child :exp, Expression
  end

  # A TwoExp class that contains two-child ast
  class TwoExp < Expression
    child :left, Expression
    child :right, Expression
  end

  # A TwoExp class that contains two-child ast
  class ThreeExp < Expression
    child :one, Expression
    child :two, Expression
    child :three, Expression
  end

  # A TwoExp class that contains two-child ast
  class FourExp < Expression
    child :one, Expression
    child :two, Expression
    child :three, Expression
    child :four, Expression
  end

  class FiveExp < Expression
    child :one, Expression
    child :two, Expression
    child :three, Expression
    child :four, Expression
    child :five, Expression
  end

  class SixExp < Expression
    child :one, Expression
    child :two, Expression
    child :three, Expression
    child :four, Expression
    child :five, Expression
    child :six, Expression
  end
  
  # parses lexical analysis tokens
  class Parser < RLTK::Parser
    
    left  :PLUS, :MINUS
    right :MULT, :DIVIDE, :MODULO
    
    production(:input, 'statements') { |s| s }

    production(:statements) do
      clause('statement statements') { |e, f| TwoExp.new(e, f) }
      clause('statement') { |e| OneExp.new(e) }
    end

    production(:statement) do
      # function declaration
      clause('DEF IDENT LPAREN identifiers RPAREN e SEMICOLON') do |d, i, _, is, _, e, _|
        id = SecureRandom.hex(8)
        SixExp.new(
          Variable.new([id, :opendef, i]),
          OneExp.new(is),
          Variable.new([id, :openfuncbody]),
          OneExp.new(e),
          Variable.new([id, :closefuncbody]),
          Variable.new([id, :closedef, i])
        )
      end

      # variable assignment
      clause('IDENT ASSIGN e SEMICOLON') do |i, _, e, _|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openassign, i]),
          OneExp.new(e),
          Variable.new([id, :closeassign, i])
        )
      end

      # vector assignment
      clause('IDENT ASSIGN LBRACKET vector RBRACKET SEMICOLON') do |i, _, _, e, _, _|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openvectordefinition, i]),
          OneExp.new(e),
          Variable.new([id, :closevectordefinition, i])
        )
      end
      
      # action
      clause('IDENT LPAREN function_arguments RPAREN SEMICOLON') do |i, _, e, _, _|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openaction, i]),
          OneExp.new(e),
          Variable.new([id, :closeaction, i])
        )
      end

      # return expression
      clause('RETURN e SEMICOLON') do |_, e, _|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openreturn]),
          OneExp.new(e),
          Variable.new([id, :closereturn])
        )
      end
    end
    
    production(:vector) do 
      clause('e COMMA vector') do |n, _, v| 
        id = SecureRandom.hex(8)
        TwoExp.new(
          OneExp.new(n),
          OneExp.new(v)
        )
      end
      
      clause('e') do |n|
        OneExp.new(n)
      end
    end

    production(:identifiers) do
      clause('IDENT COMMA identifiers') { |i, _, is| TwoExp.new(Variable.new([SecureRandom.hex(8), :identifier, i]), is)}
      clause('IDENT') { |i| Variable.new([SecureRandom.hex(8), :identifier, i])}
    end

    production(:e) do
      clause('e PLUS e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'add']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'add'])
        )
      end

      clause('e MINUS e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'subtract']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'subtract'])
        )
      end

      clause('e MULT e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'mult']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'mult'])
        )
      end

      clause('e DIVIDE e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'divide']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'divide'])
        )
      end

      clause('e MODULO e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'modulo']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'modulo'])
        )
      end

      clause('e EQUALS e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'equals']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'equals'])
        )
      end

      clause('e NE e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'ne']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'ne'])
        )
      end
      
      clause('e GTEQUALS e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'gtequals']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'gtequals'])
        )
      end

      clause('e GT e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'gt']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'gt'])
        )
      end

      clause('e LTEQUALS e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'ltequals']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'ltequals'])
        )
      end

      clause('e LT e') do |e1, _, e2|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'lt']),
          TwoExp.new(e1, e2),
          Variable.new([id, :closefunc, 'lt'])
        )
      end

      # function reference
      clause('IDENT LPAREN function_arguments RPAREN') do |f, _, e, _|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, f]),
          OneExp.new(e),
          Variable.new([id, :closefunc, f])
        )
      end

      # function reference
      clause('IDENT LPAREN RPAREN') do |f, _, _|
        id = SecureRandom.hex(8)
        TwoExp.new(
          Variable.new([id, :openfunc, f]),
          Variable.new([id, :closefunc, f])
        )
      end
      
      # constants
      clause('number') { |i| OneExp.new(i) }

      clause('LPAREN e RPAREN') { |_, e, _| e }

      clause('IDENT LBRACKET e RBRACKET') do |i, _, e, _|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openvectorref, i]),
          OneExp.new(e),
          Variable.new([id, :closevectorref, i])
        )
      end

      clause('IDENT') { |i| Variable.new([SecureRandom.hex(8), :ref, i])}
    end

    production(:number) do
      clause('INTEGER') do |i|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'const']),
          Variable.new([id, :float, i.to_f]),
          Variable.new([id, :closefunc, 'const'])
        )
      end

      clause('FLOAT') do |f|
        id = SecureRandom.hex(8)
        ThreeExp.new(
          Variable.new([id, :openfunc, 'const']),
          Variable.new([id, :float, f]),
          Variable.new([id, :closefunc, 'const'])
        )
      end
    end

    production(:function_arguments) do
      clause('e COMMA function_arguments') { |a, _, f| TwoExp.new(a, f) }
      clause('e')  { |a| OneExp.new(a) }
    end

    # finalize(explain: true)
    finalize()
  end

  class Traverser
    # @param [String] code_string code string to be parsed into ast
    # @param [Boolean] digraph
    # @return [Expression] ast created from lex/parse process
    def parse(code_string, digraph=false)
      Arbol::Parser.new.parse(
        Arbol::Lexer.new.lex(code_string),
        {:parse_tree => digraph}
      )
    end
    
    # traverses the ast and returns an intermediate representation
    # which is an array of instructions (also arrays). the arrays are created 
    # by the Variable.new([:example]) statements attached to the productions.
    # these instructions are targeted to drive the Arbol::Builder.
    # @param [Expression] ast
    # @return [Array]
    def traverse(ast)
      ret = []
      ast.each(order = :pre) do |c|
        c = c.values[0]
        ret << c if c.is_a?(Array)
      end
      ret
    end
  end
end

def traversal(code_string)
  Arbol::Traverser.new.traverse(
    Arbol::Traverser.new.parse(code_string)
  )
end
 
# require 'pp'
# 
# pp(
#   traversal(File.read(ARGV[0]))
# )


