module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def attributes
      @attributes ||= []
    end

    def validate(attribute_name, validation_type, validation_parameters = nil)
      attributes << { name: attribute_name, validation_type: validation_type,
                      validation_parameters: validation_parameters }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue ArgumentError
      false
    end

    private

    def validate_attribute_presence(name, value, _)
      raise ArgumentError, "Необходимо указать #{name}" if value.to_s.nil? || value.to_s.strip.empty?
    end

    def validate_attribute_format(name, value, format)
      raise ArgumentError, "Неверный формат #{name}" unless value.to_s =~ format
    end

    def validate_attribute_type(name, value, type)
      raise ArgumentError, "Неверный тип #{name}" unless value.instance_of?(type)
    end

    def validate!
      self.class.attributes.each do |attribute|
        attribute_value = instance_variable_get :"@#{attribute[:name]}"
        validate_method_name = "validate_attribute_#{attribute[:validation_type]}"

        send validate_method_name, attribute[:name], attribute_value, attribute[:validation_parameters]
      end
    end
  end
end
