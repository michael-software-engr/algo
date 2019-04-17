module Search
  class BinarySearch
    def initialize(list)
      @list = list
    end

    def run(search_this, raise_if_not_found: false)
      lo_ix = 0
      hi_ix = list.length - 1

      while lo_ix <= hi_ix
        mid_ix = (lo_ix + hi_ix) >> 1

        case search_this <=> list[mid_ix]
        when -1
          hi_ix = mid_ix - 1
        when 1
          lo_ix = mid_ix + 1
        else
          return mid_ix
        end
      end

      raise "'#{search_this}' not found." if raise_if_not_found
    end

    private

    attr_reader :list
  end
end
