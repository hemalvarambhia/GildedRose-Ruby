require 'spec_helper'
require 'gilded_rose'

describe 'Aged Brie' do
  let(:gilded_rose) { GildedRose.new([aged_brie]) }
  let(:aged_brie) { Item.new('Aged Brie', 4, rand(50)) }
  
  it 'reduces the number of days left to sell it' do
    expect { gilded_rose.update_quality }
      .to change { aged_brie.sell_in }.by -1
  end

  context 'when it is not passed its sell by date' do
    let(:aged_brie) { Item.new('Aged Brie', 20, 1) }

    it 'increases in quality by 1' do
      expect { gilded_rose.update_quality }
        .to change { aged_brie.quality }.by 1
    end
  end

  context 'when it hits the sell by date' do
    let(:aged_brie) { Item.new('Aged Brie', 0, 1) }

    it 'increases in quality twice as fast' do
      expect { gilded_rose.update_quality }
        .to change { aged_brie.quality }.by 2
    end
  end

  context 'when it is passed its sell by date' do
    let(:aged_brie) { Item.new('Aged Brie', -1, 1) }

    it 'increases in quality twice as fast' do
      expect { gilded_rose.update_quality }
        .to change { aged_brie.quality }.by 2
    end

    context 'and the quality is 50' do
      let(:aged_brie) { Item.new('Aged Brie', -1, 50) }

      it "doesn't change the quality" do
        expect { gilded_rose.update_quality }
          .not_to change { aged_brie.quality }
      end
    end
  end

  context 'given the quality is 50' do
    let(:aged_brie) { Item.new('Aged Brie', 2, 50) }

    it 'does not change the quality' do
      expect { gilded_rose.update_quality }
        .not_to change { aged_brie.quality }
    end
  end
end
