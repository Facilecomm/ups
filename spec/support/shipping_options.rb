module ShippingOptions
  def shipper
    {
      company_name: 'White Residence',
      attention_name: 'Walter White',
      phone_number: '01792 123456',
      address_line_1: '308 Negra Arroyo Lane',
      city: 'Albuquerque',
      state: 'New Mexico',
      postal_code: '87104',
      country: 'US',
      shipper_number: ENV['UPS_ACCOUNT_NUMBER'],
      email_address: 'nobody@example.com'
    }
  end

  def ship_to
    {
      company_name: 'Google Inc.',
      attention_name: 'Sergie Bryn',
      phone_number: '0207 031 3000',
      address_line_1: '1 St Giles High Street',
      address_line_2: 'third floor',
      address_line_3: 'appartment number 13',
      city: 'London',
      state: 'England',
      postal_code: 'WC2H 8AG',
      country: 'GB',
      email_address: 'nobody@example.com'
    }
  end

  def package
    {
      weight: '0.5',
      unit: 'KGS'
    }
  end

  def package_with_insurance
    {
      weight: '0.5',
      unit: 'KGS',
      package_service_options: {
        insured_value: {
          type: {
            code: 'EVS',
            description: 'some_description'
          },
          currency_code: 'EUR',
          monetary_value: '1650'
        }
      }
    }
  end

  def package_with_insurance_incomplete
    {
      weight: '0.5',
      unit: 'KGS',
      package_service_options: {
        insured_value: {
          type: {
            description: 'some_description'
          },
          currency_code: 'EUR',
          monetary_value: '1650'
        }
      }
    }
  end

  def package_insurance_without_descr
    {
      weight: '0.5',
      unit: 'KGS',
      package_service_options: {
        insured_value: {
          type: {
            code: 'EVS'
          },
          currency_code: 'EUR',
          monetary_value: '1650'
        }
      }
    }
  end

end
