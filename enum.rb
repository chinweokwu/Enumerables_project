module Enumerable # a generic method to repaet the values of any enumerable:helps in the reuse of methods in other mehtods
  # my_each methods
  # rubocop:disable RuleByName
  def my_each
    return to_enum(__callee__) unless block_given?
      # linter issues: linter tries to convert for to each and prints error in linter
      # pls consider it. 
    for i in self
      yield i 
    end
  end
  # rubocop:enable RuleByName

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
