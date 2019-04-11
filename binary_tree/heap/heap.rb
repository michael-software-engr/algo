# Why array.length / 2?
#   Draw the heap. Change array length. You will see that the last
#   node with children has index of array.length / 2.

class Heap
  # def self.from_array(array)
  #   start = array.length / 2

  #   start.downto(0) { |i| heapify(i) }
  # end

  attr_reader :data

  def initialize(elements, is_max_heap: true)
    @is_max_heap = is_max_heap
    @data = elements.clone

    # start = data.length - 1
    start = data.length / 2

    start.downto(0) { |idx| bubble(idx) }
  end

  # def <<(element)
  #   @data += [element]
  #   bubble(data.length - 1)
  # end

  private

  attr_reader :is_max_heap

  def left_ix_get(idx)
    2 * idx + 1
  end

  def right_ix_get(idx)
    2 * idx + 2
  end

  # def parent_ix(idx)
  #   (idx - 1) / 2
  # end

  def bubble(idx)
    left_ix = left_ix_get(idx)
    right_ix = right_ix_get(idx)

    head_ix = idx
    head_ix = left_ix if left_ix < data.length && compare(left_ix, head_ix)
    head_ix = right_ix if right_ix < data.length && compare(right_ix, head_ix)

    return if head_ix == idx

    @data[idx], @data[head_ix] = data[head_ix], data[idx]

    bubble(head_ix)
  end

  def compare(idx1, idx2)
    d1 = data[idx1]
    d2 = data[idx2]

    return d1 >= d2 if is_max_heap

    return d1 <= d2
  end
end

class HeapVerify
  attr_reader :min_heap, :data

  def initialize(*args, min_heap: false)
    @data = args
    @min_heap = min_heap
    @heap_check = ->(i, j) { return @data[i] >= @data[j] }

    if min_heap
      @heap_check = ->(i, j) { return @data[i] <= @data[j] }
    end

    build_heap
  end

  def size
    @data.size
  end

  def [](i)
    @data[i]
  end

  def push(*values)
    values.each do |val|
      @data.push(val)
      upheap(@data.size - 1)
    end
    self
  end

  def pop
    result = @data.first
    @data[0] = @data.pop
    heapify(0)
    result
  end

  def merge(heap)
    new_array = @data + heap.instance_variable_get(:@data)

    Heap.new(new_array, min_heap: self.min_heap)
  end

  def left(i)
    2 * i + 1
  end

  def right(i)
    2 * (i + 1)
  end

  def parent(i)
    (i - 1) / 2
  end

  private

  def build_heap
    start = @data.length / 2

    start.downto(0) { |i| heapify(i) }
  end

  def heapify(i)
    l = left(i)
    r = right(i)

    head = i
    head = l if l < @data.size && @heap_check.call(l, head)
    head = r if r < @data.size && @heap_check.call(r, head)

    if head != i
      @data[i], @data[head] = @data[head], @data[i]
        heapify(head)
    end
  end
end
