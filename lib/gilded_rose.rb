class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      case item.name
      when 'Sulfuras, Hand of Ragnaros'
        # NO OP
      when 'Backstage passes to a TAFKAL80ETC concert'
        update_backstage_passes(item)
      when "Aged Brie"
        update_aged_brie(item)
      else
        update_normal_item(item)
      end
    end
  end

  private

  def expired?(item)
    item.sell_in < 0
  end
  
  def increase_quality_of(item)
    if item.quality < 50
      item.quality += 1
    end
  end

  def update_sell_by_date(item)
    item.sell_in = item.sell_in - 1
  end

  def reduce_quality_of(item)
    item.quality -= 1 if item.quality > 0
  end

  def update_backstage_passes(item)
    update_sell_by_date(item)
    increase_quality_of(item)
    increase_quality_of(item) if item.sell_in < 11
    increase_quality_of(item) if item.sell_in < 6
    item.quality = 0 if expired?(item)
  end

  def update_aged_brie(item)
    update_sell_by_date(item)
    increase_quality_of(item)
    increase_quality_of(item) if expired?(item)
  end

  def update_normal_item(item)
    update_sell_by_date(item)
    reduce_quality_of(item)
    reduce_quality_of(item) if expired?(item)
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
