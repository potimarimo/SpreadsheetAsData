# coding: UTF-8

require 'data_row'

class CellRange
  
  attr_reader :sheet
  
  def initialize(corner1, corner2, sheet)
    @corner1 = sheet.cell(corner1)
    @corner2 = sheet.cell(corner2)
    @sheet = sheet
  end
  
  def book
    sheet.book
  end
  
  def upper_left_cell
    @corner1
  end
  
  def lower_right_cell
    @corner2
  end
  
  def all
    /^[A-Z]+(\d+):[A-Z]+(\d+)$/ =~ to_s
    ($1.to_i + 1).upto($2.to_i).select do |row_num|
      (upper_left_cell.column_name..lower_right_cell.column_name).any? do |column_name|
        sheet.cell_value(column_name + row_num.to_s).class != BlankValue
      end
    end.
    map{ |row_num| DataRow.new(self, row_num) }
  end
  
  def where(exp)
    result = all
    exp.each do |key, value|
      result = result.select do |row|
        case value
        when Array
          value.include? row.cell_value(key.to_s)
        else
          value === row.cell_value(key.to_s)
        end
      end
    end
    result
  end
  
  def column_names
    /^([A-Z]+)(\d+):([A-Z]+)\d+$/ =~ to_s
    ($1..$3).map do |column|
      sheet.cell_value(column + $2).to_sym
    end
  end
  
  def to_s
    "#@corner1:#@corner2"
  end
  
  alias ref to_s
end