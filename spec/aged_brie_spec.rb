require 'spec_helper'
require 'gilded_rose'

describe 'Aged Brie' do
  let(:gilded_rose) { GildedRose.new([aged_brie]) }
  let(:aged_brie) { an_aged_brie }
  
  it 'reduces the number of days left to sell it' do
    expect { gilded_rose.update_quality }
      .to change { aged_brie.sell_in }.by -1
  end

  context 'when it is not passed its sell by date' do
    let(:aged_brie) { an_aged_brie(sell_in: 20) }

    it 'increases in quality by 1' do
      expect { gilded_rose.update_quality }.to change { aged_brie.quality }.by 1
    end
  end

  context 'when it hits the sell by date' do
    let(:aged_brie) { an_aged_brie(sell_in: 0) }

    it 'increases in quality twice as fast' do
      expect { gilded_rose.update_quality }.to change { aged_brie.quality }.by 2
    end
  end

  context 'when it is passed its sell by date' do
    let(:aged_brie) { an_aged_brie(sell_in: -1) }

    it 'increases in quality twice as fast' do
      expect { gilded_rose.update_quality }
        .to change { aged_brie.quality }.by 2
    end

    context 'and the quality is 50' do
      let(:aged_brie) { an_aged_brie(sell_in: -1, quality: 50) }

      it "doesn't change the quality" do
        expect { gilded_rose.update_quality }
          .not_to change { aged_brie.quality }
      end
    end
  end

  context 'given the quality is 50' do
    let(:aged_brie) { an_aged_brie(quality: 50) }
    
    it 'does not change the quality' do
      expect { gilded_rose.update_quality }
        .not_to change { aged_brie.quality }
    end
  end

  private
  
  def an_aged_brie(sell_in: 4, quality: 25)
    Item.new('Aged Brie', sell_in, quality)
  end
end
