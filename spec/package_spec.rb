# coding: UTF-8

require 'spec_helper'
require 'package'

describe Package do
  subject { Package.open(test_file('Book1')) }
  
  after do
    subject.close
  end
  
  describe '::open' do
    it 'はブロック引数をとる。' do
      Package.open(test_file('Book1')) do |package|
        package.part('xl/workbook.xml').xml_document.should_not be_nil
      end
    end
  end
  
  describe '#root' do
    it 'が取得できる' do
      subject.root.part_uri.should == ''
      subject.root.relation('rId1').part_uri.should == ('xl/workbook.xml')
    end
  end
  
  describe '#part' do
    it 'によりPackagePartが取得できる。' do
      subject.part('xl/workbook.xml').part_uri.should == 'xl/workbook.xml'
    end
    
    it 'により取得されたPartは毎回同一になる。' do
      subject.part('xl/workbook.xml').should equal subject.part('xl/workbook.xml')
    end
  end
  
  describe '#xml_document' do
    it 'によりPackagePartから対応するXMLドキュメントがが取得できる。' do
      subject.xml_document(subject.part('xl/workbook.xml')).root.name.should == 'workbook'
    end
  end
  
  describe '#relation_tags' do
    it 'によりPackagePartから対応するリレーションが取得できる。' do
      subject.relation_tags(subject.part('xl/workbook.xml')).map{|tag| tag.attributes['Id']}.sort.should == ['rId1', 'rId2', 'rId3', 'rId4', 'rId5', 'rId6']
    end
  end
end