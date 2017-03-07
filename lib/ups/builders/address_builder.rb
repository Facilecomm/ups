# frozen_string_literal: true
require 'ox'

module UPS
  module Builders
    # The {AddressBuilder} class builds UPS XML Address Objects.
    #
    # @author Paul Trippett
    # @since 0.1.0
    # @attr [Hash] opts The Address Parts
    class AddressBuilder < BuilderBase
      class USAddressesMustHaveAState < ArgumentError; end

      include Ox

      attr_accessor :opts

      # Initializes a new {AddressBuilder} object
      #
      # @param [Hash] opts The Address Parts
      # @option opts [String] :address_line_1 Address Line 1
      # @option opts [String] :city City
      # @option opts [String] :state State
      # @option opts [String] :postal_code Zip or Postal Code
      # @option opts [String] :country Country
      # @raise [InvalidAttributeError] If the passed :state is nil or an
      #   empty string and the :country is IE
      def initialize(opts = {})
        self.opts = opts
        validate
      end

      # Changes :state part of the address based on UPS requirements
      #
      # @raise [InvalidAttributeError] If the passed :state is nil or an
      #   empty string and the :country is IE
      # @return [void]
      def validate
        opts[:state] = case opts[:country].downcase
                       when 'us'
                         normalize_us_state(opts[:state])
                       when 'ca'
                         normalize_ca_state(opts[:state])
                       when 'ie'
                         UPS::Data.ie_state_matcher(opts[:state])
                       else
                         ''
                       end
      end

      # Changes :state based on UPS requirements for US Addresses
      #
      # @param [String] state The US State to normalize
      # @return [String]
      def normalize_us_state(state)
        raise USAddressesMustHaveAState unless state
        if state.to_str.length > 2
          UPS::Data::US_STATES[state] || state
        else
          state.upcase
        end
      end

      # Changes :state based on UPS requirements for CA Addresses
      #
      # @param [String] state The CA State to normalize
      # @return [String]
      def normalize_ca_state(state)
        if state.to_str.length > 2
          UPS::Data::CANADIAN_STATES[state] || state
        else
          state.upcase
        end
      end

      # Returns an XML representation of address_line_1
      #
      # @return [Ox::Element] XML representation of address_line_1 address part
      def address_line_1
        element_with_value('AddressLine1', opts[:address_line_1][0..34])
      end

      # Returns an XML representation of address_line_2
      #
      # @return [Ox::Element] XML representation of address_line_2 address part
      def address_line_2
        data = opts.key?(:address_line_2) ? opts[:address_line_2][0..34] : ''
        element_with_value('AddressLine2', data)
      end

      # Returns an XML representation of city
      #
      # @return [Ox::Element] XML representation of the city address part
      def city
        element_with_value('City', opts[:city][0..29])
      end

      # Returns an XML representation of state
      #
      # @return [Ox::Element] XML representation of the state address part
      def state
        element_with_value('StateProvinceCode', opts[:state])
      end

      # Returns an XML representation of postal_code
      #
      # @return [Ox::Element] XML representation of the postal_code address part
      def postal_code
        element_with_value('PostalCode', opts[:postal_code][0..9])
      end

      # Returns an XML representation of country
      #
      # @return [Ox::Element] XML representation of the country address part
      def country
        element_with_value('CountryCode', opts[:country][0..1])
      end

      # Returns an XML representation of email
      #
      # @return [Ox::Element] XML representation of the email address
      def email_address
        element_with_value('EmailAddress', opts[:email_address][0..49])
      end

      # Returns an XML representation of a UPS Address
      #
      # @return [Ox::Element] XML representation of the current object
      def to_xml
        Element.new('Address').tap do |address|
          setup_address address
        end
      end

      private

      ADDRESS_FIELDS = %i(
        address_line_1
        address_line_2
        email_address
        city
        state
        postal_code
        country
      ).freeze
      private_constant :ADDRESS_FIELDS

      def setup_address(address)
        ADDRESS_FIELDS.each do |field|
          next if field == :email_address && !opts[:email_address]
          address << send(field)
        end
      end
    end
  end
end
