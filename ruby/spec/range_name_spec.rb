# coding: UTF-8

require 'spec_helper'

describe RangeName do
  describe '::valid?' do
    it 'は有効な範囲ではtrueとなります。' do
      RangeName.valid?('A1:A1').should be_truthy
    end
    it 'は無効な範囲ではfalseとなります。' do
      RangeName.valid?('A1:').should be_falsey
      RangeName.valid?(':B2').should be_falsey
    end
    
    it 'はメソッド呼び出しではなく、when句に利用しても使えます。' do
      RangeName.valid?.should === 'A1:A1'
      RangeName.valid?.should_not === 'A1:'
    end
    
    it 'はメソッド呼び出しではなく、when句に利用した時に列指定に対応します。' do
      RangeName.valid?.should === 'A:A'
      RangeName.valid?.should === 'B:C'
    end
  end
  describe 'をハッシュのキーとして利用する時に、RangeName' do
    let(:hash) { { RangeName.new('A1:B2') => 1 } }
    it 'は位置が同じ時に同値と判定されます。' do
      hash[RangeName.new('A1:B2')].should == 1
    end
    it 'は左上セルが違うときにに同値ではないと判定されます。' do      
      hash[RangeName.new('B2:B2')].should be_nil
    end
    it 'は右下セルが違うときにに同値ではないと判定されます。' do      
      hash[RangeName.new('A1:A1')].should be_nil
    end
  end
  describe '#initialize' do
    context 'はセル指定の場合' do
      context 'は一つの引数で使われた時に' do
        it 'は文字列を受け取ります。' do
          RangeName.new('A1:A1').to_s.should == 'A1:A1'
          RangeName.new('B2:C3').to_s.should == 'B2:C3'
        end
        it 'はシンボルを受け取ります。' do
          RangeName.new(:A1_A1).to_s.should == 'A1:A1'
          RangeName.new(:B2_C3).to_s.should == 'B2:C3'
        end
      end
      context 'は二つの引数で使われた時に' do
        it 'は文字列を受け取ります。' do
          RangeName.new('A1','A1').to_s.should == 'A1:A1'
          RangeName.new('B2','C3').to_s.should == 'B2:C3'
        end
        it 'はシンボルを受け取ります。' do
          RangeName.new(:A1,:A1).to_s.should == 'A1:A1'
          RangeName.new(:B2,:C3).to_s.should == 'B2:C3'
        end
        it 'は文字列とシンボルを受け取ります。' do
          RangeName.new('A1',:A1).to_s.should == 'A1:A1'
          RangeName.new(:B2,'C3').to_s.should == 'B2:C3'
        end
      end
    end
    context 'は列指定の場合' do
      context 'は一つの引数で使われた時に' do
        it 'は文字列を受け取ります。' do
          RangeName.new('A:A').to_s.should == 'A:A'
          RangeName.new('B:C').to_s.should == 'B:C'
        end
        it 'はシンボルを受け取ります。' do
          RangeName.new(:A_A).to_s.should == 'A:A'
          RangeName.new(:B_C).to_s.should == 'B:C'
        end
      end
      context 'は二つの引数で使われた時に' do
        it 'は文字列を受け取ります。' do
          RangeName.new('A','A').to_s.should == 'A:A'
          RangeName.new('B','C').to_s.should == 'B:C'
        end
        it 'はシンボルを受け取ります。' do
          RangeName.new(:A,:A).to_s.should == 'A:A'
          RangeName.new(:B,:C).to_s.should == 'B:C'
        end
        it 'は文字列とシンボルを受け取ります。' do
          RangeName.new('A',:B).to_s.should == 'A:B'
          RangeName.new(:B,'C').to_s.should == 'B:C'
        end
      end
    end
  end
  describe '#upper_left' do
    context 'はセル指定の場合' do
      it 'で左上のセルを取得できます。' do
        RangeName.new('A1:A1').upper_left.to_s.should == 'A1'
        RangeName.new('B2:C3').upper_left.to_s.should == 'B2'
      end
      describe 'は指定時の順番ではなく位置関係で、' do
        it '上下を判別します' do
          RangeName.new('A2:A1').upper_left.to_s.should == 'A1'
        end
        it '左右を判別します' do
          RangeName.new('B1:A1').upper_left.to_s.should == 'A1'
        end
      end
      it '文字列比較ではなく数値比較で左右を判別します' do
        RangeName.new('A10:A2').upper_left.to_s.should == 'A2'
      end
    end
    context 'は列指定の場合' do
      it 'で左上のセルを取得できます。' do
        RangeName.new('A:A').upper_left.to_s.should == 'A1'
        RangeName.new('B:C').upper_left.to_s.should == 'B1'
      end
      describe 'は指定時の順番ではなく位置関係で、' do
        it '左右を判別します' do
          RangeName.new('B:A').upper_left.to_s.should == 'A1'
        end
      end
    end
    it 'は無効な範囲名を指定したときnilとなります。' do
      RangeName.new('*').upper_left.should be_nil
    end
  end
  describe '#lower_right' do
    context 'はセル指定の場合' do
      it 'で左下のセルを取得できます' do
        RangeName.new('A1:A1').lower_right.to_s.should == 'A1'
        RangeName.new('B2:C3').lower_right.to_s.should == 'C3'
      end
      describe 'は指定時の順番ではなく位置関係で、' do
        it '上下を判別します' do
          RangeName.new('A2:A1').lower_right.to_s.should == 'A2'
        end
        it '左右を判別します' do
          RangeName.new('B1:A1').lower_right.to_s.should == 'B1'
        end
      end
    end
    context 'は列指定の場合' do
      it 'で左下のセルを取得できます' do
        RangeName.new('A:A').lower_right.to_s.should == 'A1048576'
        RangeName.new('B:C').lower_right.to_s.should == 'C1048576'
      end
      describe 'は指定時の順番ではなく位置関係で、' do
        it '上下を判別します' do
          RangeName.new('B:A').lower_right.to_s.should == 'B1048576'
        end
      end
    end
    it 'は無効な範囲名を指定したときnilとなります。' do
        RangeName.new('A').lower_right.should be_nil
      end
  end
  describe '#valid?' do
    context 'はセル指定の場合' do
      it 'は有効な範囲ではtrueとなります。' do
        RangeName.new('A1:A1').valid?.should be_truthy
      end
      it 'は無効な範囲ではfalseとなります。' do
        RangeName.new('A1:').valid?.should be_falsey
        RangeName.new(':A1').valid?.should be_falsey
      end
      it 'は左上のセルが無効な位置なら無効とします。' do
        RangeName.new('XFE1:A1').should_not be_valid
      end
    end
    context 'は列指定の場合' do
      it 'は有効な範囲ではtrueとなります。' do
        RangeName.new('A:B').valid?.should be_truthy
      end
      it 'は左の列が無効な位置なら無効とします。' do
        RangeName.new('XFE:A').should_not be_valid
      end
    end
  end
  describe '#columns?' do
    context 'はセル指定の場合' do
      it 'にtrueとなります。' do
        RangeName.new('A:A').columns?.should be_truthy
      end
    end
    context 'は列指定の場合' do
      it 'は行のみの指定ではない時にfalseとなります。' do
        RangeName.new('A1:A1').columns?.should be_falsey
      end
    end
  end
  describe '#sheet' do
    context 'はセル指定の場合' do
      it 'はシート名を取得できます。' do
        RangeName.new('Sheet1!A1:A1').sheet.should == 'Sheet1'
        RangeName.new('Sheet2!A1:A1').sheet.should == 'Sheet2'
      end
      it 'はシート名の指定がない場合にnilを取得しますす。' do
        RangeName.new('A1:A1').sheet.should be_nil
      end
    end
    context 'は列指定の場合' do
      it 'はシート名を取得できます。' do
        RangeName.new('Sheet1!A:A').sheet.should == 'Sheet1'
        RangeName.new('Sheet2!A:A').sheet.should == 'Sheet2'
      end
      it 'はシート名の指定がない場合にnilを取得しますす。' do
        RangeName.new('A:A').sheet.should be_nil
      end
    end
  end
  describe '#to_s' do
    context 'はセル指定の場合' do
      it 'はA1:A1形式で文字列を返します。' do
        RangeName.new('A1:A1').to_s.should == 'A1:A1'
        RangeName.new('B2:C3').to_s.should == 'B2:C3'
      end
    end
    context 'は列指定の場合' do
      it 'はA:A形式で返します。' do
        RangeName.new('A:A').to_s.should == 'A:A'
        RangeName.new('B:C').to_s.should == 'B:C'
      end
    end
    it 'は無効な場合は"{invalid range}"を返します。' do
      RangeName.new('A1:').to_s.should == '{invalid range}'
    end
  end
end