class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      next if item.name == "Sulfuras, Hand of Ragnaros"
      item.sell_in = item.sell_in - 1
      case item.name
      when 'Backstage passes to a TAFKAL80ETC concert'
        increase_quality_of(item)
        increase_quality_of(item) if item.sell_in < 11
        increase_quality_of(item) if item.sell_in < 6
      when "Aged Brie"
        increase_quality_of(item)
      else
        reduce_quality_of(item)
      end

      if expired?(item)
        case item.name
        when 'Aged Brie'
          increase_quality_of(item)
        when 'Backstage passes to a TAFKAL80ETC concert'
          item.quality = 0
        else
          reduce_quality_of(item)
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
