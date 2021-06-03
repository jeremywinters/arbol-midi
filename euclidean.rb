require 'pp'
require 'flatten'

def euclidean(first, second)
  front = []
  until (first.empty? or second.empty?) do
    front << [first.shift, second.shift]
  end
  back = first + second
  
  unless (back.length <= 1)
    front, back = euclidean(front, back)
  end
  # pp([front, back])
  return [front, back]
end

PP.singleline_pp(
  euclidean(
    Array.new(ARGV[0].to_i, 1),
    Array.new(ARGV[1].to_i - ARGV[0].to_i, 0)
  ).flatten
)
puts