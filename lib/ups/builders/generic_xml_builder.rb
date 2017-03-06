require 'ox'

module UPS
  module Builders
    class GenericXMLBuilder
      include Ox

      def initialize(hash:, root:, optional_fields: [])
        @hash = hash
        @root = root
        @optional_fields = wrap optional_fields
      end

      # def capitalize_element(element)
      #   return deep_capitalize_array(element) if element.is_a? Array
      #   element.to_s.split('_').map(&:capitalize).join
      # end

      # def deep_capitalize_array(array)
      #   wrap(array).map do |element|
      #     capitalize_element(element)
      #   end
      # end

      def to_ox_element
        @current_path = nil
        ox_element = Element.new(@root)
        deep_build ox_element, @hash
        ox_element
      end

      private

      def wrap(object)
        return object if object.is_a? Array
        [object]
      end

      def deep_build(xml,hash)
        hash.each do |key, value|
          next if value.nil? && @optional_fields.include?(key)
          if value.is_a? String
            basic_step(xml,key,value)
            next
          end
          append_to_current camelize(key)
          elem = Element.new(camelize(key))
          deep_build(elem,value)
          xml << elem
        end
      end

      def basic_step(xml, key, value)
        ox_element = xml.locate(camelize(@current_path)).first
        if ox_element.nil?
          xml << create_new_element(key,value)
          return xml
        end
        ox_element << create_new_element(key,value)
        ox_element
      end

      def append_to_current(name)
        # return @current_path = name if @current_path.nil?
        @current_path = "#{@current_path}/#{name}"
      end

      def create_new_element(key, value)
        elem = Element.new(camelize(key))
        elem << value.to_s
        @current_path = nil
        elem
      end

      def camelize(name)
        name && name.to_s.split('_').map(&:capitalize).join
      end
    end
  end
end
