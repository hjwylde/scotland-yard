require 'rails_helper'

RSpec.describe Node, :type => :model do

  describe '#origin?' do
    context 'by default' do
      it 'is false' do
        expect(Node.create!.origin?).to be_falsey
      end
    end
  end

  describe '#origin=' do
    it 'fails'
  end

  describe '#incoming_nodes' do
    context 'with no routes' do
      it 'is empty' do
        expect(Node.create!.incoming_nodes).to be_empty
      end
    end

    context 'with multiple routes' do
      let(:node) { Node.all[1] }

      it 'has all the linked nodes' do
        expect(node.incoming_nodes).to match_array node.incoming_routes.map(&:from_node)
      end
    end
  end

  describe '#outgoing_nodes' do
    context 'with no routes' do
      it 'is empty' do
        expect(Node.create!.outgoing_nodes).to be_empty
      end
    end

    context 'with multiple routes' do
      let(:node) { Node.all[1] }

      it 'has all the linked nodes' do
        expect(node.outgoing_nodes).to match_array node.outgoing_routes.map(&:to_node)
      end
    end
  end

  describe '#routes' do
    context 'with no incoming or outgoing routes' do
      it 'is empty' do
        expect(Node.create!.routes).to be_empty
      end
    end

    context 'with multiple incoming and outgoing routes' do
      let(:node) { Node.all[1] }

      it 'has all the incoming and outgoing routes' do
        expect(node.linked_nodes).to match_array (node.incoming_nodes + node.outgoing_nodes)
      end

      it 'is an ActiveRecord::Relation' do
        expect(node.routes.class).to eq ActiveRecord::Relation
      end
    end
  end

  describe '#linked_nodes' do
    context 'with no routes' do
      it 'is empty' do
        expect(Node.create!.linked_nodes).to be_empty
      end
    end

    context 'with multiple routes' do
      let(:node) { Node.all[1] }

      it 'returns the unique set of nodes' do
        expect(node.linked_nodes).to match_array (node.incoming_nodes + node.outgoing_nodes).uniq - [self]
      end

      it 'is an ActiveRecord::Relation' do
        expect(node.linked_nodes.class).to eq ActiveRecord::Relation
      end
    end
  end

  describe '#transport_modes' do
    context 'with no routes' do
      it 'is empty' do
        expect(Node.create!.transport_modes).to be_empty
      end
    end

    context 'with multiple routes' do
      let(:node) { Node.all[1] }

      it "returns the unique union of the routes' transport modes" do
        expect(node.transport_modes).to match_array node.routes.map(&:transport_mode).uniq
      end
    end
  end
end

