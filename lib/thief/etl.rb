module Thief
  class ETL
    def download_file(uri, target_name)
      begin
        FileUtils.mkdir_p "#{Thief.tmp_dir}/#{self.class.source_name}/cache"

        puts "downloading #{uri}..."
        source_file = open(uri)

        destination = "#{Thief.tmp_dir}/#{self.class.source_name}/cache/#{target_name}"

        target_file = File.open(destination, 'wb')
        target_file.write(source_file.read)
        target_file.close
      rescue
        target_file && FileUtils.rm(target_file)
      end        
    end
    
    def extract_file(filename, target_name)
      begin
        source_path = "#{Thief.tmp_dir}/#{self.class.source_name}/cache/#{filename}"
        destination = "#{Thief.tmp_dir}/#{self.class.source_name}/#{target_name}"

        puts "extracting #{filename} to #{destination}..."

        source_file = File.open(source_path, 'rb')
        unzipped_source = Zlib::GzipReader.new(source_file)

        target_file = File.open(destination, 'wb')
        target_file.write(unzipped_source.read)
        target_file.close
        
        source_file.close
      rescue
        target_file && FileUtils.rm(target_file)
      end
    end
    
    def download_and_extract_file(uri, target_name)
      unless cached?(target_name)
        filename = uri.split('/').last
        download_file(uri, filename) unless cached?(filename)
        extract_file(filename, target_name)
      end
    end
    
    def cached?(filename)
      File.exists?("#{Thief.tmp_dir}/#{self.class.source_name}/cache/#{filename}")
    end
    
  private
  
    def self.source_name
      name.split('::')[1]
    end

    def namespace
      Thief.const_get(self.class.source_name)
    end  
  end  
end

