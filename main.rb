module Enumerable
  # each
  def my_each
    for i in self
      yield i
    end
    end

  # each_with_index
  def my_each_with_index
    result = self.map do |element, index|
      yield "#{index}: #{element} "
    end
    result
  end

  # select
  def my_select
    result = []
    for i in self
      result << i if yield(i)
    end
    result 
   end

  # all
  def my_all?
    self.my_each do |elememt|
      return false unless yield(element)
    end
    true
  end

  # any
  def my_any?
    self.my_each do |elememt|
      return true if yield(element)
    end
    false
  end

  # negated
  def my_none?
    self.my_each do |element|
      yield(element)
    end
  end

  # count 
  def my_count(element = false)
    return length if elememt == false && !block_given?
    arr = []
    if element
      to_a.my_each do |e|
        arr << e if e == element
      else
      to_a.my_each do |e|
        arr << e if yield(e)
    end
    arr.length
  end

  # map 
  def my_map(&procs)
    arr = []
    my_each do |element|
      arr << procs.call(element)
    end
    arr
  end

  # inject iterator
  def my_inject
    accmulator = self[0]
    my_each do |i|
      accmulator += i 
    end
    accmulator
  end
end

num = Lambda {|element| element * 2 }
puts arr.my_map(&num)

def multiply_els(arr)
  arr.my_inject { |accmulator, current_value| accmulator * current_value}
end
puts multiply_els([2, 4, 5])

# arr = [1,2,3,4,5]
# arr = [4, 'hey', 2, true, :job]
# arr.my_each
# arr.my_each_with_index { |element, index| puts "#{index}: #{element}"}

# arr = [1..20]
# arr.my_select do |i|
#    if i % 2 == 0 
#     result << i
#    end
# end

# arr = [4, 'hey', 2, true, :job]
# puts arr.my_all {|element| element.is_a? string}

# arr = [4, 'hey', 2, true, :job]
# puts arr.my_any {|element| element.is_a? string}

# arr = [4, 'hey', 2, true, :job]
# puts arr.my_none |element| 
  # if element.is_a? string
  #   return false
  # else return true
  # end
# end

# arr = [1,2,3,4,5]
# puts arr.my_inject

