﻿require 'fileutils'
require 'rexml/document'

require 'Package'
require 'Cell'

# Excelのシートです。
class WorkSheet
	# インスタンスを初期化します。
	def initialize(tag, doc)
		@tag = tag
		@xml = doc
		@cell_hash = {}
	end
	
	# シート名を取得します。
	def name
		@tag.attributes['name'].encode('Shift_JIS')
	end
	
	def cell_value(ref)
		cell = cell(ref)
		cell.value if cell
	end
	
	def cell(ref)
		cell = @cell_hash[ref]
		return cell if cell
		xml = @xml.elements.to_a('//c').find{|c| c.attributes['r'] == ref.to_s}
		if xml then
			cell = Cell.new(xml)
			@cell_hash[ref] = cell
		end
	end
	
	def method_missing(method_name)
		value = self.cell_value(method_name)
		if value.nil? then super else value end
	end
end