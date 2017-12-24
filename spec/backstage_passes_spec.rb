require 'spec_helper'
require 'gilded_rose'

describe 'Backstage passes to a TAFKAL80ETC concert' do
  let(:gilded_rose) { GildedRose.new([backstage_pass]) }
  let(:backstage_pass) { a_backstage_pass }

  it 'reduces the number of days left to sell it' do
    expect { gilded_rose.update_quality }.to(
      change { backstage_pass.sell_in }.by -1
    )
  end

  context 'when there are more than 10 days until the concert' do
    it 'increases in quality by 1' do
      expect { gilded_rose.update_quality }.to(
        change { backstage_pass.quality }.by 1
      )
    end

    context 'when the item quality is 50' do
      let(:backstage_pass) { a_backstage_pass(quality: 50) }
      
      it 'does not increase in quality' do
        expect { gilded_rose.update_quality }.not_to change { backstage_pass.quality }.from 50
      end
    end
  end

  context 'when there exactly 10 days left until the concert' do
    let(:backstage_pass) { a_backstage_pass(sell_in: 10) }

    it 'increases the quality by 2' do
      expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.by 2
    end

    context 'and the quality is 49' do
      let(:backstage_pass) { a_backstage_pass(sell_in: 10, quality: 49) }

      it 'changes the quality to 50' do
        expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.to(50)
      end        
    end
  end

  context 'when there are between 10 and 6 days left until the concert' do
    let(:backstage_pass) { a_backstage_pass(sell_in: 8) }

    it 'increases the quality by 2' do
      expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.by 2
    end

    context 'and the quality is 49' do
      let(:backstage_pass) { a_backstage_pass(sell_in: 8, quality: 49) }

      it 'changes the quality to 50' do
        expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.to(50)
      end        
    end
  end

  context 'when there are 5 days left until the concert' do
    let(:backstage_pass) { a_backstage_pass(sell_in: 5) }

    it 'increases the quality by 2' do
      expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.by 3
    end

    context 'and the quality is 49' do
      let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 49) }

      it 'changes the quality to 50' do
        expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.to(50)
      end        
    end
  end

  context 'when there are 5 days or less left until the concert' do
    let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 3, 10) }

    it 'increases the quality by 2' do
      expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.by 3
    end
  end

  context 'on the day of the concert' do
    let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 10) }

    it 'reduces the quality to 0' do
      expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.to 0
    end
  end

  context 'after the concert has passed' do
    let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', -2, 10) }

    it 'is worth nothing' do
      expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.to 0
    end
  end

  private

  def a_backstage_pass(sell_in: 12, quality: 10)
    Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, quality)
  end
end
