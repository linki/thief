require File.expand_path('spec_helper', File.dirname(__FILE__))

module Thief
  describe Cleaner do
    before do
      Thief::Person.delete_all
    end

    it "should clean same first and last name" do
      person1 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse')
      person2 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Rourke')
      person3 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse')
    
      Thief.cleaner.cleanup
    
      Thief::Person.count.should == 2      
      Thief::Person.all.should == [person1, person2]
    end

    it "should merge missing attributes" do
      person1 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse', :gender => nil)
      person2 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse', :gender => 'Male')

      Thief.cleaner.cleanup
      
      Thief::Person.count.should == 1
      person1.reload.gender.should == 'Male'
    end
    
    it "should clean similar dates" do
      person1 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse', :date_of_birth => Date.new(1989, 5, 20))
      person2 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse', :date_of_birth => Date.new(1989, 5, 22))
      person3 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse', :date_of_birth => Date.new(1989, 8, 13))      
      
      Thief.cleaner.cleanup
      
      Thief::Person.count.should == 2
    end

  end
end