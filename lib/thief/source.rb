module Thief
  class Source
    def self.inherited(base)
      Bundler.require(base.source_name.downcase) if defined?(Bundler)
    end

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
    
    def self.source_name
      name.split('::').last
    end
    
    def namespace
      Thief.const_get(self.class.source_name)
    end
  end
end
  