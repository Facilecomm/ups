module UPS
  module Tools
    class InvalidOptsParams < StandardError; end
    # same as Array.wrap in rails
    # "9" return ["9"]  ["9"] return ["9"]
    # usefull before a .each
    def wrap(element)
      return element if element.is_a? Array
      [element]
    end

    def check_params(paths, opts: ,name: )
      wrap(paths).each do |path|
        fail(
          InvalidOptsParams,
          "#{name} #{path} is not correctly set"
        ) if deep_extract(path, hash: opts).nil?
      end
    end

    # allows to retrieve deep_data
    def deep_extract(path, hash: )
      adapted_path = wrap path
      deep_size = adapted_path.count
      deep_size.times do |time|
        extracted_data = hash[adapted_path[time]]
        return nil if extracted_data.nil?
        hash = extracted_data
      end
      hash
    end

    # # a.split('_').map(&:capitalize).join
    # class XmlBuilderFromHash
    #   include Ox
    #   include Tools

    #   def initialize(hash:,root:,optional_fields: [])
    #     @hash = hash
    #     @root = root
    #     @optional_fields = wrap optional_fields
    #   end

    #   def deep_capitalize_array(array)
    #     wrap(array).map do |element|
    #       capitalize_element(element)
    #     end
    #   end

    #   def capitalize_element(element)
    #     return deep_capitalize_array(element) if element.is_a? Array
    #     element.to_s.split('_').map(&:capitalize).join
    #   end

    #   def to_ox
    #     @current_path = nil
    #     xml = Element.new(@root)
    #     deep_build(xml,@hash)
    #     xml
    #   end

    #   def deep_build(xml,hash)
    #     hash.each do |key, value|
    #       next if value.nil? && @optional_fields.include?(key)
    #       if value.is_a? String
    #         basic_step(xml,key,value)
    #         next
    #       end
    #       build_current_path(adapte_name(key))
    #       elem = Element.new(adapte_name(key))
    #       deep_build(elem,value)
    #       xml << elem
    #     end
    #   end

    #   def basic_step(xml,key,value)
    #     ox_element = xml.locate(adapte_name(@current_path)).first
    #     if ox_element.nil?
    #       xml << create_new_element(key,value)
    #       return xml
    #     end
    #     ox_element << create_new_element(key,value)
    #     ox_element
    #   end

    #   def build_current_path(name)
    #     return @current_path = name if @current_path.nil?
    #     @current_path = "#{@current_path}/#{name}"
    #   end

    #   def adapte_name(name)
    #     return nil if name.nil?
    #     name.to_s.split('_').map(&:capitalize).join
    #   end

    #   def create_new_element(key,value)
    #     elem = Element.new(adapte_name(key))
    #     elem << value.to_s
    #     @current_path = nil
    #     elem
    #   end
    # end
  end
end
