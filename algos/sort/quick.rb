module Sort
  def quick_sort(array)
    return array if array.length <= 1

    pivot_ix = rand array.length
    pivot = array[pivot_ix]

    left = []
    right = []

    array.each.with_index do |x, ix|
      next if ix == pivot_ix

      if x <= pivot
        left << x
      else
        right << x
      end
    end

    return *quick_sort(left), pivot, *quick_sort(right)
  end

  class << self
    include Sort
  end
end
