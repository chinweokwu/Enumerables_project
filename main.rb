module Enumerable
  # each
  def my_each
    result = self.map do |element|
      yield element 
    end
    result
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
    arr = []
    self.my_each do |element|
      arr << element if  yield(elememt)
    end
    arr
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
    !(self.my_all? {|item| yield(item)})
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
    my_each do |e|
      accmulator = yield(accmulator, current_value)
    end
    accmulator
  end
end

num = ->(e) { e * 2 }
p arr.my_map(&num)

def multiply_els(arr)
  arr.my_inject { |accmulator, current_value| accmulator * current_value}
end
puts multiply_els([2, 4, 5])
