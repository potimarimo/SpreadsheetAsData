# coding: UTF-8

require 'spec_helper'

describe RangeName do
  describe '::valid?' do
    it 'は有効な範囲ではtrueとなる' do
      RangeName.valid?('A1:A1').should be_true
    end
    it 'は無効な範囲ではfalseとなる' do
      RangeName.valid?('A1:').should be_false
      RangeName.valid?(':B2').should be_false
    end
  end
  describe '#initialize' do
    it 'は文字列を受け取ります。' do
      RangeName.new('A1:A1').to_s.should == 'A1:A1'
      RangeName.new('B2:C3').to_s.should == 'B2:C3'
    end
    it 'はシンボルを受け取ります。' do
      RangeName.new(:A1_A1).to_s.should == 'A1:A1'
      RangeName.new(:B2_C3).to_s.should == 'B2:C3'
    end
  end
  describe '#upper_left' do
    it 'で左上のセルを取得できます。' do
      RangeName.new('A1:A1').upper_left.to_s.should == 'A1'
      RangeName.new('B2:C3').upper_left.to_s.should == 'B2'
    end
    it 'は無効な範囲名を指定したときnilとなります。' do
      RangeName.new('A').upper_left.should be_nil
    end
    describe 'は指定時の順番ではなく位置関係で、' do
      it '左右を判別します' do
        RangeName.new('A2:A1').upper_left.to_s.should == 'A1'
      end
      it '上下を判別します' do
        RangeName.new('B1:A1').upper_left.to_s.should == 'A1'
      end
    end
    it '文字列比較ではなく数値比較で左右を判別します' do
      RangeName.new('A10:A2').upper_left.to_s.should == 'A2'
    end
  end
  describe '#lower_right' do
    it 'で左下のセルを取得できます' do
      RangeName.new('A1:A1').lower_right.to_s.should == 'A1'
      RangeName.new('B2:C3').lower_right.to_s.should == 'C3'
    end
    it 'は無効な範囲名を指定したときnilとなります。' do
      RangeName.new('A').lower_right.should be_nil
    end
    describe 'は指定時の順番ではなく位置関係で、' do
      it '左右を判別します' do
        RangeName.new('A2:A1').lower_right.to_s.should == 'A2'
      end
      it '上下を判別します' do
        RangeName.new('B1:A1').lower_right.to_s.should == 'B1'
      end
    end
  end
  describe '#valid?' do
    it 'は有効な範囲ではtrueとなります。' do
      RangeName.new('A1:A1').valid?.should be_true
    end
    it 'は無効な範囲ではfalseとなります。' do
      RangeName.new('A1:').valid?.should be_false
      RangeName.new(':A1').valid?.should be_false
    end
    it 'は左上のセルが無効な位置なら無効とします。' do
      RangeName.new('XFE1:A1').should_not be_valid
    end
  end
  describe '#to_s' do
    it 'はA1:A1形式で文字列を返します。' do
      RangeName.new('A1:A1').to_s.should == 'A1:A1'
      RangeName.new('B2:C3').to_s.should == 'B2:C3'
    end
    it 'は無効な場合は"{invalid range}"を返します。' do
      RangeName.new('A1:').to_s.should == '{invalid range}'
    end
  end
end