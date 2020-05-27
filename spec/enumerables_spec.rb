require './lib/enum'

describe Enumerable do
  let(:arr) { [1, 2, 3, 4, 'hi'] }
  let(:arr_num) { [1, 2, 3, 4, 5, 6] }
  let(:arr_str) { %w[ant bear cat] }
  let(:arr_nums) { [1, 2i, 3.14] }

  context '#my_each' do
    it 'displays enumerable when no block given' do
      expect(arr.my_each).to be_a(Enumerable)
    end

    it 'returns array when block given' do
      expect(arr.my_each { |x| x }).to eq(arr.each { |x| x })
    end
  end

  context '#my_each_with_index' do
    it 'displays enumerable when no block given' do
      expect(arr_str.my_each_with_index).to be_a(Enumerable)
    end

    it 'return an array with index when block given' do
      expect(arr_str.my_each_with_index { |_vals, index| _vals = index }).to eq(arr_str.each_with_index { |_vals, index| _vals = index })
    end
  end

  context '#my_select' do
    it 'displays enumerable when no block given' do
      expect(arr_str.my_select).to be_a(Enumerable)
    end

    it 'return the selected values' do
      expect(arr.my_select { |_nums| _nums = 4 }).to eq(arr.select { |_nums| _nums = 4 })
    end
  end

  context '#my_all' do
    it 'displays enumerable when no block is given ' do
      expect(arr_str.my_all?).to eq(true)
    end

    it 'returns true when all length is greater than or equal to 3' do
      expect(arr_str.my_all? { |word| word.length >= 3 }).to eq(arr_str.all? { |word| word.length >= 3 })
    end

    it 'returns false when all length is greater than or equal to 4' do
      expect(arr_str.my_all? { |word| word.length >= 4 }).to eq(arr_str.all? { |word| word.length >= 4 })
    end

    it '' do
      expect(arr_str.my_all?(/d/)).to eq(arr_str.all?(/d/))
    end

    it 'it return true' do
      expect([].my_all?).to eq([].all?)
    end
  end

  context '#my_any' do
    it 'displays enumerable when no block is given ' do
      expect(arr_num.my_any?).to eq(arr_num.any?)
    end

    it 'returns true when any length is greater than or equal 3' do
      expect(arr_str.my_any? { |word| word.length >= 3 }).to eq(arr_str.any? { |word| word.length >= 3 })
    end

    it 'returns false when any length is greater than or equal to 4' do
      expect(arr_str.my_any? { |word| word.length >= 4 }).to eq(arr_str.any? { |word| word.length >= 4 })
    end

    it 'it return true' do
      expect([].my_any?).to eq([].any?)
    end
  end

  context '#my_none' do
    it 'displays enumerable when no block is given ' do
      expect(arr_str.my_none?).to eq(arr_str.my_none?)
    end

    it 'displays true when word length is equal to 5' do
      expect(arr_str.my_none? { |word| word.length == 5 }).to eq(arr_str.none? { |word| word.length == 5 })
    end

    it 'displays false when word length is greater than or equal to 4' do
      expect(arr_str.my_none? { |word| word.length == 4 }).to eq(arr_str.none? { |word| word.length == 4 })
    end
  end

  context '#my_count' do
    it 'display length no block given and no argument' do
      expect(arr_num.my_count).to eq(arr_num.count)
    end

    it 'displays count 6' do
      expect(arr_num.my_count(6)).to eq(arr_num.count(6))
    end

    it 'display count less than 5' do
      expect(arr_num.my_count { |x| x < 5 }).to eq(arr_num.count { |x| x < 5 })
    end
  end

  context '#my_map' do
    procs = proc { |num| num * 2 }
    it 'displays enumerable when no block is given ' do
      expect(arr_str.my_map).to be_a(Enumerable)
    end

    it 'displays arr_num greater than 4' do
      expect(arr_num.my_map { |num| num > 4 }).to eq(arr_num.map { |num| num > 4 })
    end

    it 'displays the result in the procs' do
      expect(arr_num.my_map(&procs)).to eq(arr_num.map(&procs))
    end

    it 'displays an array' do
      expect((1..4).my_map { |i| i * i }).to eq((1..4).map { |i| i * i })
    end
  end

  context '#my_inject' do
    it 'display the sum of arr_num' do
      expect(arr_num.my_inject(:+)).to eq(arr_num.inject(:+))
    end

    it 'display the sum of the range' do
      expect((5..10).my_inject { |sum, n| sum + n }).to eq((5..10).inject { |sum, n| sum + n })
    end

    it 'display the sum of the range and argument' do
      expect((5..10).my_inject(2) { |sum, n| sum + n }).to eq((5..10).inject(2) { |sum, n| sum + n })
    end
  end
end
