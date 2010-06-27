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

    it "should clean" do
      person1 = Thief::Person.create(:first_name => 'Amy', :last_name => 'Adams', :date_of_birth => Date.new(1974, 8, 20), :place_of_birth => 'Vincenza, Italy', :profession => 'Actor')
      person2 = Thief::Person.create(:first_name => 'Amy', :last_name => 'Adams', :date_of_birth => Date.new(1974, 8, 20), :place_of_birth => 'Aviano, Italien', :profession => 'Actor')
      person3 = Thief::Person.create(:first_name => 'Amy', :last_name => 'Adams', :place_of_birth => 'Greater Auckland')
      person4 = Thief::Person.create(:first_name => 'Amy', :last_name => 'Adams', :place_of_birth => 'Kansas City', :profession => 'Singer')
      person5 = Thief::Person.create(:first_name => 'Amy', :last_name => 'Adams', :place_of_birth => 'Vincenza', :profession => 'Actor')
      
      Thief.cleaner.cleanup
      
      Thief::Person.count.should == 3
    end

  it "should clean Mickey" do
    person1 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse', :profession => 'Actor', :date_of_birth => Date.new(1928, 11, 18), :place_of_birth => 'USA')
    person2 = Thief::Person.create(:first_name => 'Micky', :last_name => 'Mouse', :profession => 'Actor, Singer')
    person3 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse')
    person4 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse', :place_of_birth => 'Detroit, USA')
    person5 = Thief::Person.create(:first_name => 'Mickey', :last_name => 'Mouse', :profession => 'Politician', :date_of_birth => Date.new(1960, 8, 12))
    
    Thief.cleaner.cleanup
  
    Thief::Person.count.should == 2      
    Thief::Person.all.should == [person1, person5]
  end
  

  end
end