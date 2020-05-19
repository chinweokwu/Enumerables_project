# rubocop: disable Metrics/ModuleLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength

module Enumerable
  # my_each methods
  def my_each
    return to_enum(__callee__) unless block_given?

    arr = to_a
    size = arr.length
    x = 0
    until x == size
      yield(arr[x])
      x += 1
    end
    self
  end

  # my_each_with_index
  def my_each_with_index
    return to_enum(__callee__) unless block_given?

    arr = to_a
    size = arr.length
    x = 0
    until x == size
      yield(arr[x], x)
      x += 1
    end
    self
  end

  # my_select method
  def my_select
    return to_enum(__callee__) unless block_given?

    results = []
    my_each do |element|
      results << element if yield(element)
    end
    results
  end

  # my_all method
  def my_all?(arg = nil)
    bool = true
    if block_given? && arg.nil?
      my_each { |val| bool = false unless yield(val) }
    elsif arg.is_a? Regexp
      my_each { |val| bool = false unless val =~ arg }
    elsif arg.is_a? Class
      my_each { |val| bool = false unless val.is_a? arg }
    elsif arg
      bool = true
      my_each do |val|
        bool = true if val == arg && bool == true
        bool = false if val != arg && bool == true
      end
    else
      bool = true
      my_each do |val|
        bool = true if val && bool == true
        bool = false if (val.nil? || val == false) && bool == true
      end
    end
    bool
  end

  # my_any
  def my_any?(arg = nil)
    bool = false
    if block_given? && arg.nil?
      my_each { |val| bool = true if yield(val) }
    elsif arg.is_a? Regexp
      my_each { |val| bool = true if val =~ arg }
    elsif arg.is_a? Class
      my_each { |val| bool = true if val.is_a? arg }
    elsif arg
      bool = false
      my_each { |val| bool = true if val == arg && bool == false }
    else
      bool = false
      my_each { |val| bool = true if val && bool == false }
    end
    bool
  end

  # my_none method
  def my_none?(arg = nil)
    bool = true
    if block_given? && arg.nil?
      my_each { |val| bool = false if yield(val) }
    elsif arg.is_a? Regexp
      my_each { |val| bool = false if val =~ arg }
    elsif arg.is_a? Class
      my_each { |val| bool = false if val.is_a? arg }
    elsif arg
      my_each { |val| bool = false if val == arg }
    else
      my_each { |val| bool = false if val }
    end
    bool
  end

  # my_count method
  def my_count(arg = nil)
    count = 0
    size = length
    if !block_given? && arg.nil?
      count = size
    elsif arg
      my_each { |element| count += 1 if element == arg }
    else
      my_each { |element| count += 1 if yield(element) }
    end
    count
  end

  # my_map method
  def my_map(proc = nil)
    return to_enum(__callee__) unless block_given?

    arr = to_a
    new_arr = []
    if !proc.nil?
      arr.my_each { |element| new_arr << proc.call(element) }
    else
      arr.my_each { |element| new_arr << yield(element) }
    end
    new_arr
  end

  # my_inject method
  def my_inject(acc = nil, arg = nil)
    arr = to_a
    if block_given?
      if acc.nil?
        val = arr[0]
        arr[1...arr.length].my_each do |element|
          val = yield(val, element)
        end
      else
        val = acc
        arr.my_each do |element|
          val = yield(val, element)
        end
      end
    elsif !acc.nil? && !arg.nil?
      val = acc
      arr.my_each do |element|
        val = val.send(arg, element)
      end
    elsif !acc.nil? && arg.nil?
      val = arr[0]
      arr[1...arr.length].my_each do |element|
        val = val.send(acc, element)
      end
    end
    val
  end
end

def multiply_els(arr)
  arr.my_inject { |accumulator, current_val| accumulator * current_val }
end

# rubocop: enable Metrics/ModuleLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
# rubocop:enable Metrics/MethodLength:
puts 'my_each'

[1, 2, 3, 4, 'hi'].my_each do |x|
  puts x
end
puts [2, 4, 7, 11].my_each # <Enumerator: [2, 4, 7, 11]:my_each>

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_each_with_index'

[1, 2, 3, 4, 'hi'].my_each_with_index { |value, index| puts "#{value} => #{index}" }
puts [2, 4, 7, 11].my_each_with_index # <Enumerator: [2, 4, 7, 11]:my_each_with_index

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_select'

result = [1, 2, 3, 4, 5, 6].select(&:even?) #=> [2, 4, 6]
puts result
block = proc { |_num| num = 11 }
puts [2, 4, 7, 11].my_select(&block) #=> [11]
puts [2, 4, 7, 11].my_select # <Enumerator: [2, 4, 7, 11]:my_select>
puts [1, 2].my_select { |num| num == 1 } #=> [1]

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_all?'

puts %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true
puts %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
puts %w[ant bear cat].my_all?(/t/) #=> false
puts [1, 2i, 3.14].my_all?(Numeric) #=> true
puts [nil, true, 99].my_all? #=> false
puts [].my_all? #=> true
puts [nil, false, true, []].my_all? #=> false
puts [1, 2.5, 'a', 9].my_all?(Integer) #=> false
puts %w[dog door rod blade].my_all?(/d/) #=> true
puts [3, 4, 7, 11].my_all?(3) #=> false
puts [1, false].my_all? #=> false

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_any??'

puts %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
puts %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
puts %w[ant bear cat].my_any?(/d/) #=> false
puts [nil, true, 99].my_any?(Integer) #=> true
puts [nil, true, 99].my_any? #=> true
puts [].my_any? #=> false
puts [nil, false, true, []].my_any? #=> true
puts [1, 2.5, 'a', 9].my_any?(Integer) #=> true
puts %w[dog door rod blade].my_any?(/d/) #=> true
puts [3, 4, 7, 11].my_any?(3) #=> true
puts [1, false].my_any? #=> true
puts [1].my_any? #=> true
puts [nil].my_any? #=> false
puts [nil, false, nil, false].my_any? #=> false

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_none?'

puts %w[ant bear cat].my_none? { |word| word.length == 5 } #=> true
puts %w[ant bear cat].my_none? { |word| word.length >= 4 } #=> false
puts %w[ant bear cat].my_none?(/d/) #=> true
puts [1, 3.14, 42].my_none?(Float) #=> false
puts [].my_none? #=> true
puts [nil].my_none? #=> true
puts [nil, false].my_none? #=> true
puts [nil, false, true].my_none? #=> false
puts [nil, false, true, []].my_none? #=> false
puts [1, 2.5, 'a', 9].my_none?(Integer) #=> false
puts %w[dog door rod blade].my_none?(/d/) #=> false
puts [3, 4, 7, 11].my_none?(3) #=> false

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_count'

ary = [1, 2, 4, 2]
puts ary.my_count #=> 4
puts ary.my_count(2) #=> 2
puts ary.my_count(&:even?) #=> 3

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_map'

puts (1..4).my_map { |i| i * i } #=> [1, 4, 9, 16]
puts (1..4).my_map { 'dog' } #=> ["dog", "dog", "dog", "dog"]
puts %w[a b c].my_map(&:upcase) #=> ["A", "B", "C"]
puts %w[a b c].my_map(&:class) #=> [String, String, String]
puts [2, 4, 7, 11].my_map # <Enumerator: [2, 4, 7, 11]:my_map
my_proc = proc { |num| num > 10 }
puts [18, 22, 5, 6] .my_map(my_proc) { |num| num < 10 } # true true false false

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'my_inject'

longest = %w[cat sheep bear].my_inject do |memo, word|
  memo.length > word.length ? memo : word
end

puts longest #=> "sheep"

puts (5..10).my_inject { |sum, n| sum + n } #=> 45
puts (5..10).my_inject(2) { |sum, n| sum + n } #=> 47
puts (1..5).my_inject(4) { |prod, n| prod * n } #=> 480
puts [1, 1, 1].my_inject(:+) #=> 3
puts [1, 1, 1].my_inject(2, :+) #=> 5

puts '-*-*-*-*-*-*-*-*-*-*-*-*-'
puts 'multiply_els'

puts multiply_els([2, 4, 5]) #=> 40
