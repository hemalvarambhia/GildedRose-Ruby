require 'spec_helper'
require 'gilded_rose'
describe 'Normal Item' do
  let(:gilded_rose) { GildedRose.new([normal_item]) }

  context 'when the item is not passed its sell by date' do
    let(:normal_item) { Item.new('Normal Item', 20, 30) }

    it 'degrades in quality by 1' do
      expect { gilded_rose.update_quality }
        .to change { normal_item.quality }.by -1
    end

    it 'reduces the number of days left to sell it' do
      expect { gilded_rose.update_quality }
        .to change { normal_item.sell_in }.by -1
    end

    context 'when the quality is 0' do
      let(:normal_item) { Item.new('Normal Item', 20, 0) }

      it "doesn't change from 0" do
        expect { gilded_rose.update_quality }
          .not_to change { normal_item.quality }.from 0
      end
    end
  end

  context 'when the hits its sell by date' do
    let(:normal_item) { Item.new('Normal Item', 0, 10) }
    it 'degrades the quality twice as fast' do
      expect { gilded_rose.update_quality }
        .to change { normal_item.quality }. by -2
    end

    it 'reduces the number of days left to sell by 1' do
      expect { gilded_rose.update_quality }
        .to change { normal_item.sell_in }. by -1
    end
  end

  context 'when it is passed its sell by date' do
    let(:normal_item) { Item.new('Normal Item', -1, 10) }
    it 'degrades the quality twice as fast' do
      expect { gilded_rose.update_quality }
        .to change { normal_item.quality }. by -2
    end

    it 'reduces the number of days left to sell by 1' do
      expect { gilded_rose.update_quality }
        .to change { normal_item.sell_in }. by -1
    end

    context 'and the quality is already 0' do
      let(:normal_item) { Item.new('Normal Item', -1, 0) }

      it 'remains at 0' do
        expect { gilded_rose.update_quality }
          .not_to change { normal_item.quality }.from 0
      end
    end
  end
end
