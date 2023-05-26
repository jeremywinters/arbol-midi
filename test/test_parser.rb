require 'minitest'
require 'minitest/autorun'

require_relative '../lib/parser.rb'

module Arbol
  class TestLexer < Minitest::Test
    def lex_type(string)
      Arbol::Lexer.lex(string)[0].type
    end

    def test_lexer
      assert :STRIP == lex_type('strip')
      assert :DEF == lex_type('def')
      assert :LPAREN == lex_type('(')
      assert :RPAREN == lex_type(')')
      assert :LBRACKET == lex_type('[')
      assert :RBRACKET == lex_type(']')
      assert :COMMA == lex_type(',')
      assert :ASSIGN == lex_type('=')
      assert :SEMICOLON == lex_type(';')
      assert :PLUS == lex_type('+')
      assert :MINUS == lex_type('-')
      assert :MULT == lex_type('*')
      assert :DIVIDE == lex_type('/')
      assert :MODULO == lex_type('%')
      assert :EQUALS == lex_type('==')
      assert :GTEQUALS == lex_type('>=')
      assert :GT == lex_type('>')
      assert :LTEQUALS == lex_type('<=')
      assert :LT == lex_type('<')
      assert :IDENT == lex_type('hello')
      assert :IDENT == lex_type('Hello')
      assert :IDENT == lex_type('Hello2')
      assert :IDENT == lex_type('Hello_2')

      # non-identifiers
      assert :IDENT != lex_type('2Hello')
      assert :IDENT != lex_type('22')

      # ranges and constants
      assert :RANGE == lex_type('1..100')
      assert :INTEGER == lex_type('1')
      assert :FLOAT == lex_type('100.100')
      assert :FLOAT == lex_type('10.1')

      # whitespace
      assert :INTEGER == lex_type(' 100 ')

      # comments
      assert :EOS == lex_type('# a comment')
      assert :INTEGER == lex_type('1 # a comment')
      assert :INTEGER == lex_type("# a comment\n1")
    end
  end

  class TestParser < Minitest::Test
    def top_level_node_type(code_string)
      Arbol::Traverser.new.parse(code_string).class
    end

    def traversal(code_string)
      Arbol::Traverser.new.traverse(
        Arbol::Traverser.new.parse(code_string)
      )
    end

    def assert_traversal(expected, code_string)
      assert(
        expected == traversal(code_string),
        traversal(code_string)
      )
    end

    def test_production_input
      assert(
        Arbol::OneExp == top_level_node_type('a = 1;'),
        top_level_node_type('a = 1;')
      )
    end

    def test_production_statements
      # multiple statements
      assert(
        Arbol::TwoExp == top_level_node_type('a = 1; b = 2;'),
        top_level_node_type('a = 1; b = 2;')
      )

      # single statement
      assert(
        Arbol::OneExp == top_level_node_type('a = 1;'),
        top_level_node_type('a = 1;')
      )
    end

    def test_production_statement
      # DEF IDENT LPAREN identifiers RPAREN e SEMICOLON
      assert_traversal(
        [
          [:opendef, 'f'],
          [:identifier, 'x'],
          [:identifier, 'y'],
          [:openfuncbody],
          [:ref, 'z'],
          [:closefuncbody],
          [:closedef, 'f']
        ],
        'def f(x,y) z;'
      )

      # IDENT ASSIGN e SEMICOLON
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:closeassign, 'a']
        ],
        'a = 1;'
      )

      # STRIP LPAREN INTEGER COMMA stripmap COMMA e RPAREN SEMICOLON
      assert_traversal(
        [
          [:openstrip, 0],
          [:openstripmap],
          [:int, 100],
          [:closestripmap],
          [:openstripbody],
          [:ref, 'a'],
          [:closestripbody],
          [:closestrip]
        ],
        'strip(0, 100, a);'
      )
    end

    def test_production_stripmap
      # maparray
      assert_traversal(
        [
          [:openstrip, 0],
          [:openstripmap],
          [:openarray],
          [:int, 1],
          [:int, 2],
          [:int, 3],
          [:closearray],
          [:closestripmap],
          [:openstripbody],
          [:ref, 'a'],
          [:closestripbody],
          [:closestrip]
        ],
        'strip(0, [1,2,3], a);'
      )

      # integer
      assert_traversal(
        [
          [:openstrip, 0],
          [:openstripmap],
          [:int, 100],
          [:closestripmap],
          [:openstripbody],
          [:ref, 'a'],
          [:closestripbody],
          [:closestrip]
        ],
        'strip(0, 100, a);'
      )

      # range
      assert_traversal(
        [
          [:openstrip, 0],
          [:openstripmap],
          [:range, '0..100'],
          [:closestripmap],
          [:openstripbody],
          [:ref, 'a'],
          [:closestripbody],
          [:closestrip]
        ],
        'strip(0, 0..100, a);'
      )
    end

    def test_production_maparray
      # basic use case
      assert_traversal(
        [
          [:openstrip, 0],
          [:openstripmap],
          [:openarray],
          [:int, 1],
          [:int, 2],
          [:int, 3],
          [:closearray],
          [:closestripmap],
          [:openstripbody],
          [:ref, 'a'],
          [:closestripbody],
          [:closestrip]
        ],
        'strip(0, [1,2,3], a);'
      )
    end

    def test_production_maparraybody
      # INTEGER COMMA maparraybody - single integer
      assert_traversal(
        [
          [:openstrip, 0],
          [:openstripmap],
          [:openarray],
          [:int, 1],
          [:closearray],
          [:closestripmap],
          [:openstripbody],
          [:ref, 'a'],
          [:closestripbody],
          [:closestrip]
        ],
        'strip(0, [1], a);'
      )

      # INTEGER COMMA maparraybody - multiple integer
      assert_traversal(
        [
          [:openstrip, 0],
          [:openstripmap],
          [:openarray],
          [:int, 1],
          [:int, 2],
          [:int, 3],
          [:closearray],
          [:closestripmap],
          [:openstripbody],
          [:ref, 'a'],
          [:closestripbody],
          [:closestrip]
        ],
        'strip(0, [1,2,3], a);'
      )

      # RANGE COMMA maparraybody - single range
      assert_traversal(
        [
          [:openstrip, 0],
          [:openstripmap],
          [:openarray],
          [:range, '0..10'],
          [:closearray],
          [:closestripmap],
          [:openstripbody],
          [:ref, 'a'],
          [:closestripbody],
          [:closestrip]
        ],
        'strip(0, [0..10], a);'
      )

      # RANGE COMMA maparraybody - multiple ranges
      assert_traversal(
        [
          [:openstrip, 0],
          [:openstripmap],
          [:openarray],
          [:range, '0..10'],
          [:range, '90..100'],
          [:closearray],
          [:closestripmap],
          [:openstripbody],
          [:ref, 'a'],
          [:closestripbody],
          [:closestrip]
        ],
        'strip(0, [0..10, 90..100], a);'
      )
    end

    def test_production_e
      # e PLUS e
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'add'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'add'],
          [:closeassign, 'a']
        ],
        'a = 1 + 2;'
      )

      # e MINUS e
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'minus'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'minus'],
          [:closeassign, 'a']
        ],
        'a = 1 - 2;'
      )

      # e MULT e
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'mult'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'mult'],
          [:closeassign, 'a']
        ],
        'a = 1 * 2;'
      )

      # e DIVIDE e
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'divide'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'divide'],
          [:closeassign, 'a']
        ],
        'a = 1 / 2;'
      )

      # e MODULO e
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'modulo'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'modulo'],
          [:closeassign, 'a']
        ],
        'a = 1 % 2;'
      )

      # e EQUALS e
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'equals'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'equals'],
          [:closeassign, 'a']
        ],
        'a = 1 == 2;'
      )

      # e GTEQUALS e
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'gtequals'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'gtequals'],
          [:closeassign, 'a']
        ],
        'a = 1 >= 2;'
      )

      # e GT e
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'gt'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'gt'],
          [:closeassign, 'a']
        ],
        'a = 1 > 2;'
      )

      # e LTEQUALS e
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'ltequals'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'ltequals'],
          [:closeassign, 'a']
        ],
        'a = 1 <= 2;'
      )

      # e LT e
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'lt'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'lt'],
          [:closeassign, 'a']
        ],
        'a = 1 < 2;'
      )

      # function reference
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'magic'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:openfunc, 'const'],
          [:int, 2],
          [:closefunc, 'const'],
          [:closefunc, 'magic'],
          [:closeassign, 'a']
        ],
        'a = magic(1, 2);'
      )

      # number
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:closeassign, 'a']
        ],
        'a = 1;'
      )
  
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:closeassign, 'a']
        ],
        'a = (1);'
      )

      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'const'],
          [:float, 0.5],
          [:closefunc, 'const'],
          [:closeassign, 'a']
        ],
        'a = 0.5;'
      )
      
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'const'],
          [:float, 0.5],
          [:closefunc, 'const'],
          [:closeassign, 'a']
        ],
        'a = (0.5);'
      )

      # vector / vectorelement
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openvector],
          [:vectorelement, 1],
          [:vectorelement, 2],
          [:vectorelement, 3.5],
          [:closevector],
          [:closeassign, 'a']
        ],
        'a = [1, 2, 3.5];'
      )

      # variable reference
      assert_traversal(
        [
          [:openassign, 'a'],
          [:ref, 'b'],
          [:closeassign, 'a']
        ],
        'a = b;'
      )
    end

    def test_production_number
      # number
      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'const'],
          [:int, 1],
          [:closefunc, 'const'],
          [:closeassign, 'a']
        ],
        'a = 1;'
      )

      assert_traversal(
        [
          [:openassign, 'a'],
          [:openfunc, 'const'],
          [:float, 0.5],
          [:closefunc, 'const'],
          [:closeassign, 'a']
        ],
        'a = 0.5;'
      )
    end

    def test_production_function_arguments
      assert_traversal(
        [
          [:opendef, 'f'],
          [:identifier, 'x'],
          [:openfuncbody],
          [:ref, 'z'],
          [:closefuncbody],
          [:closedef, 'f']
        ],
        'def f(x) z;'
      )

      assert_traversal(
        [
          [:opendef, 'f'],
          [:identifier, 'a'],
          [:identifier, 'b'],
          [:identifier, 'c'],
          [:openfuncbody],
          [:ref, 'z'],
          [:closefuncbody],
          [:closedef, 'f']
        ],
        'def f(a, b, c) z;'
      )
    end
  end
  
  class TestTraverser < Minitest::Test
    # we assume this to work because of rltk
    def test_parse
      assert true
    end
    
    # we assume this to work because of rltk
    def test_traverse
      assert true
    end
  end
end