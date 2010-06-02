module DataMapper
  module Model
    def delete_all
      repository.delete(self.all)
    end
  end
end

DataMapper::Property::DEFAULT_LENGTH = 255