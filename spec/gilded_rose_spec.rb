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

  describe 'Backstage passes to a TAFKAL80ETC concert' do
    let(:gilded_rose) { GildedRose.new([backstage_pass]) }
    let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 12, 10) }

    it 'reduces the number of days left to sell it' do
      expect { gilded_rose.update_quality }.to change { backstage_pass.sell_in }.by -1
    end

    context 'when there are more than 10 days until the concert' do
      it 'increases in quality by 1' do
        expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.by 1
      end

      context 'when the item quality is 50' do
        let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 12, 50) }
        it 'does not increase in quality' do
          expect { gilded_rose.update_quality }.not_to change { backstage_pass.quality }.from 50
        end
      end
    end

    context 'when there exactly 10 days left until the concert' do
      let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 10) }

      it 'increases the quality by 2' do
        expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.by 2
      end

      context 'and the quality is 49' do
        let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 49) }

        it 'changes the quality to 50' do
          expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.to(50)
        end        
      end
    end

    context 'when there are between 10 and 6 days left until the concert' do
      let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 8, 10) }

      it 'increases the quality by 2' do
        expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.by 2
      end

      context 'and the quality is 49' do
        let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 8, 49) }

        it 'changes the quality to 50' do
          expect { gilded_rose.update_quality }.to change { backstage_pass.quality }.to(50)
        end        
      end
    end

    context 'when there are 5 days left until the concert' do
      let(:backstage_pass) { Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 10) }

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
  end

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
end
