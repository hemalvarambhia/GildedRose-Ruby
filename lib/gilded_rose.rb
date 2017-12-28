class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      next if item.name == "Sulfuras, Hand of Ragnaros"
      if item.name == "Aged Brie" || item.name == "Backstage passes to a TAFKAL80ETC concert"
        increase_quality_of(item)
        if item.name == "Backstage passes to a TAFKAL80ETC concert"
          increase_quality_of(item) if item.sell_in < 11
          increase_quality_of(item) if item.sell_in < 6
        end
      else
        reduce_quality_of(item)
      end

      item.sell_in = item.sell_in - 1

      if expired?(item)
        if item.name == "Aged Brie"
          increase_quality_of(item)
        else
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            reduce_quality_of(item)
          else
            item.quality = 0
          end
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
