require 'spec_helper'

RSpec.describe AttributeFilter do
  context 'it changes attributes according to passing parameters' do
    class TestClass
    end
    
    before(:each) do
      @test_class = TestClass.new
      @test_class.extend(AttributeFilter)
      @test_class.instance_variable_set('@name'.to_sym, ' John Smith     ')
      @test_class.instance_variable_set('@email'.to_sym, 'CaseSensitive@mail.com')
    end
    
    it "can downcase attribute" do
      @test_class.filter_attributes([:name, :email], :downcase)
      expect(@test_class.instance_variable_get('@name'.to_sym)).to eql(' john smith     ')
      expect(@test_class.instance_variable_get('@email'.to_sym)).to eql('casesensitive@mail.com')
    end
    
    it "can trim attribute" do
      @test_class.filter_attributes([:name, :email], :trim)
      expect(@test_class.instance_variable_get('@name'.to_sym)).to eql('John Smith')
      expect(@test_class.instance_variable_get('@email'.to_sym)).to eql('CaseSensitive@mail.com')
    end
    
    it "can acquire more than one filter function" do
      @test_class.filter_attributes([:name, :email], :trim, :downcase)
      expect(@test_class.instance_variable_get('@name'.to_sym)).to eql('john smith')
      expect(@test_class.instance_variable_get('@email'.to_sym)).to eql('casesensitive@mail.com')
    end

    it "call the block if block present and no methods given" do
      @test_class.filter_attributes([:name, :email]) do |attr|
        attr.strip!
        attr.gsub!(/(Smith)/, 'Brayan')
        attr.gsub!(/(mail)/, 'yahoo')
        attr.upcase
      end
      expect(@test_class.instance_variable_get('@name'.to_sym)).to eql('JOHN BRAYAN')
      expect(@test_class.instance_variable_get('@email'.to_sym)).to eql('CASESENSITIVE@YAHOO.COM')
    end
    
    it "raise an error if undefined method passed" do
      expect do
        @test_class.filter_attributes([:name, :email], :trim, :downcase, :typocommand)
      end.to raise_error(ArgumentError)
    end

  end
  
  
end
