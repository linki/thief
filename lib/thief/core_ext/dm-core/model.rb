module DataMapper
  module Model
    def delete_all
      repository.delete(self.all)
    end
  end
end