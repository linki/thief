module Thief
  class Source
    def fetch
      etl.fetch
    end
    
    def integrate
      integrator.integrate
    end
    
    def etl
      @etl ||= namespace::ETL.new
    end
    
    def integrator
      @integrator ||= namespace::Integrator.new
    end
    
  private
    
    def source_name
      self.class.name.split('::').last
    end
    
    def namespace
      Thief.const_get(source_name)
    end
  end
end
  