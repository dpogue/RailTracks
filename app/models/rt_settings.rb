class RtSettings < RailsSettings::Settings
  
  def self.update_attributes(hash)
    raise ArgumentError unless hash.is_a?(Hash)

    hash.each do |k,v|
      self[k] = v
    end
  end
end
