require "attribute_filter/version"

module AttributeFilter
  extend self
  RESERVED_FILTERS = [:downcase, :trim]
  #
  # if plain return plain
  # if active_record/active_model return active_record/active_model
  def filter_attributes(attr_names, *filter_criterias, &block)
    attr_names.each do |attr_name|
      if !filter_criterias.empty?
        #can change iterator below to chain methods
        filter_criterias.each do |filter_criteria|
          if RESERVED_FILTERS.include?(filter_criteria.to_sym)
            instance_variable_set("@#{attr_name}", AttributeFilter.send(filter_criteria,(instance_variable_get("@#{attr_name}"))))
          else
            raise ArgumentError, "Wrong formatter method called"
          end
        end
      elsif block_given?
        instance_variable_set("@#{attr_name}", block.call(instance_variable_get("@#{attr_name}")))
      end
    end
  end
  
  def downcase(attr_name)
    attr_name.downcase
  end
  
  def trim(attr_name)
    attr_name.strip
  end
end
