require_relative '../../../../algos/binary_tree/binary_search_tree/binary_search_tree'

# To display the tree...
# require_relative '../../../../algos/binary_tree/binary_search_tree/renderer'
# BinarySearchTree::Renderer.new(bst.root_node).render(bname: 'rspec')

# rubocop:disable Metrics/BlockLength
describe BinarySearchTree do
  inputs = Array.new(ARGV&.first&.to_i || 10) { rand 99 }.freeze
  inputs_sorted_uniq = inputs.sort.uniq.freeze

  let(:bst) { BinarySearchTree.from_array_to_bst inputs }

  it 'works even if input have duplicate values'

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
    traversal_inputs = [11, 59, 71, 14, 70, 57, 53, 88, 30].freeze
    # Has duplicate (14), TODO later
    # traversal_inputs = [11, 59, 71, 14, 70, 57, 53, 88, 14, 30].freeze

    let(:bst) { BinarySearchTree.from_array_to_bst traversal_inputs }

    [
      [:depth_first_traversal, [57, 14, 11, 30, 53, 70, 59, 71, 88]],
      [:breadth_first_traversal, [57, 14, 70, 11, 30, 59, 71, 53, 88]]
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

  describe '#lca' do
    # rubocop:disable Layout/AlignArray, Layout/ExtraSpacing
    lca_inputs = [
       7, 80, 32,  2, 89, 86, 27, 25, 12,  7, 21, 36, 61, 31, 22,
      29, 42, 88, 52, 40,  1, 62, 39, 92, 91, 49,  1, 75, 75,  9
    ].freeze
    # rubocop:enable Layout/AlignArray, Layout/ExtraSpacing
    lca_p = 2
    lca_q = 32
    lca = 12

    let(:bst) { BinarySearchTree.from_array_to_bst lca_inputs }

    it "finds #{lca} as least common ancestor of #{lca_p} and #{lca_q}" do
      expect(bst.lca(lca_p, lca_q).value).to eq lca
    end

    context 'when a node is not found' do
      it 'raises an exception' do
        non_existent_node = 123
        expect { bst.lca(non_existent_node, 0) }.to raise_error(
          RuntimeError,
          "Can't find LCA because value '#{non_existent_node}' doesn't exist in tree."
        )
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
