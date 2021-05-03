# arbol-midi

## To Do

* implement reference types
  * types = expression, vector
  * memory_indices = []
  * duplicate names throw error
* create vector defintition as an executable.
	* vector def will not create an instruction.
	* create vector reference at constructor time.
      * first param (indx - 1) is a reference to index 0
      * second param (indx) is the count of items
   * pass through parameter resolution because no instruction
* vector reference object
  * has mem_indx
  * (indx - 3) vector indx from expression
  * (indx - 2) vector start
  * (indx - 1) vector length
* execute once instructions
  * set `one_time` in constructor
      * true = execute only once is possible (not guaranteed)
      * false = execute every time because function is volatile or depends on time
  * during optimization phase...
      * `one_time` = true if and only if all child expressions are true
 
## Phases

* lexer
* parser
* builder
    * references
    * 
* optimizer
* instructions