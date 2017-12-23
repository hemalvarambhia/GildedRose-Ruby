class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if item.name == "Aged Brie" || item.name == "Backstage passes to a TAFKAL80ETC concert"
        increase_quality_of(item)
        if item.name == "Backstage passes to a TAFKAL80ETC concert"
          increase_quality_of(item) if item.sell_in < 11
          increase_quality_of(item) if item.sell_in < 6
        end
      else
        reduce_quality_of(item) unless item.name == "Sulfuras, Hand of Ragnaros"
      end

      item.sell_in = item.sell_in - 1 unless item.name == "Sulfuras, Hand of Ragnaros"

      if expired?(item)
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.name != "Sulfuras, Hand of Ragnaros"
              reduce_quality_of(item)
            end
          else
            item.quality = 0
          end
        else
          increase_quality_of(item)
        end
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

  def reduce_quality_of(item)
    item.quality -= 1 if item.quality > 0
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
