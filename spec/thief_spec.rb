require File.expand_path('spec_helper', File.dirname(__FILE__))

module Thief
  describe Cleaner do
    it "should clean" do
      person1 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse')
      person2 = Thief::Person.create(:first_name => 'Mini', :last_name => 'Mouse')
      person3 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Rourke')
      person4 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse')

      Thief::Cleaner.new.cleanup
      
      Thief::Person.all.should == [person1, person2, person3]
    end
  end
end