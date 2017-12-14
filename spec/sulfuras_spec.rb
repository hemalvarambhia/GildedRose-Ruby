require 'spec_helper'
require 'gilded_rose'

describe GildedRose do
  describe 'Sulfuras, Hand of Ragnaros' do
    let(:gilded_rose) { GildedRose.new([sulfuras]) }
    let(:sulfuras) { Item.new('Sulfuras, Hand of Ragnaros', 5, 80) }

    it 'is never sold' do
      expect { gilded_rose.update_quality }.not_to change { sulfuras.sell_in } 
    end
    
    it 'never changes in quality' do
      expect { gilded_rose.update_quality }.not_to change { sulfuras.quality }
    end
  end
end
