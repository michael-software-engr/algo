require_relative '../../../../algos/binary_tree/binary_search_tree/binary_search_tree'

# rubocop:disable Metrics/BlockLength
describe BinarySearchTree do
  inputs = Array.new(ARGV&.first&.to_i || 10) { rand 99 }.freeze
  inputs_sorted_uniq = inputs.sort.uniq.freeze

  let(:bst) { BinarySearchTree.from_array_to_bst inputs }

  describe '::from_array_to_bst' do
    it 'returns BinarySearchTree object' do
      expect(bst.is_a?(BinarySearchTree)).to eq true
    end
  end

  describe 'Search' do
    %i[include? depth_first_search breadth_first_search].each do |search_method|
      describe search_method do
        [
          [-1, false],
          [inputs.first, true],
          [inputs[rand(inputs.count - 1)], true],
          [inputs.last, true],
          [123, false]
        ].each do |(search_for_this, exp_is_found)|
          verb = (exp_is_found ? 'finds' : 'does not find').freeze

          it "#{verb} #{search_for_this}" do
            expect(bst.public_send(search_method, search_for_this)).to eq exp_is_found
          end
        end
      end
    end
  end

  describe 'Order' do
    [
      [:in_order, inputs_sorted_uniq], [:out_order, inputs_sorted_uniq.reverse]
    ].each do |(order_method, exp)|
      describe order_method do
        it 'works' do
          expect(bst.public_send(order_method)).to eq exp
        end
      end
    end
  end

  describe 'Traversal' do
    traversal_inputs = [11, 59, 71, 14, 70, 57, 53, 88, 14, 30].freeze

    let(:bst) { BinarySearchTree.from_array_to_bst traversal_inputs }

    [
      [:depth_first_traversal, [57, 14, 11, 53, 30, 71, 70, 59, 88]],
      [:breadth_first_traversal, [57, 14, 71, 11, 53, 70, 88, 30, 59]]
    ].each do |(traversal_method, exp)|
      describe traversal_method do
        it 'works' do
          expect(bst.public_send(traversal_method)).to eq exp
        end
      end
    end
  end

  describe '#delete' do
    delete_this = inputs_sorted_uniq[rand(inputs_sorted_uniq.count - 1)]
    without_deleted_item = inputs_sorted_uniq.reject { |item| item == delete_this }.freeze

    let(:bst_after_delete) { bst.delete delete_this }

    it "does not include deleted node value, '#{delete_this}'" do
      expect(bst_after_delete.include?(delete_this)).to eq false
    end

    describe 'Order' do
      [
        [:in_order, without_deleted_item], [:out_order, without_deleted_item.reverse]
      ].each do |(order_method, exp)|
        describe order_method do
          it 'works' do
            expect(bst_after_delete.public_send(order_method)).to eq exp
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
