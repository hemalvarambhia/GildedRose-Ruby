require 'spec_helper'
require 'gilded_rose'
describe 'Normal Item' do
  let(:gilded_rose) { GildedRose.new([normal_item]) }

  context 'when the item is not passed its sell by date' do
    let(:normal_item) { a_normal_item(sell_in: 20) }

    it 'degrades in quality by 1' do
      expect { gilded_rose.update_quality }
        .to change { normal_item.quality }.by -1
    end

    it 'reduces the number of days left to sell it' do
      expect { gilded_rose.update_quality }
        .to change { normal_item.sell_in }.by -1
    end

    context 'when the quality is 0' do
      let(:normal_item) { a_normal_item(quality: 0) }

      it "doesn't change from 0" do
        expect { gilded_rose.update_quality }
          .not_to change { normal_item.quality }.from 0
      end
    end
  end

  context 'when the hits its sell by date' do
    let(:normal_item) { a_normal_item(sell_in: 0) }
    
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
    let(:normal_item) { a_normal_item(sell_in: -1) }
    
    it 'degrades the quality twice as fast' do
      expect { gilded_rose.update_quality }
        .to change { normal_item.quality }. by -2
    end

    it 'reduces the number of days left to sell by 1' do
      expect { gilded_rose.update_quality }
        .to change { normal_item.sell_in }. by -1
    end

    context 'and the quality is already 0' do
      let(:normal_item) { a_normal_item(sell_in: -1, quality: 0) }

      it 'remains at 0' do
        expect { gilded_rose.update_quality }
          .not_to change { normal_item.quality }.from 0
      end
    end
  end

  private

  def a_normal_item(sell_in: 30, quality: 25)
    Item.new('Normal Item', sell_in, quality)
  end
end
