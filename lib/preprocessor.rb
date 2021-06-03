module Arbol
  class Preprocessor
    attr_accessor :src_file
    def initialize(file_path)
      @src_file = File.read(file_path)
    end 
    
    def expand_includes(source_string)
      
    end
    
    def processed
      
    end
  end
end