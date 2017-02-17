require 'spec_helper'

class UPS::Builders::TestBuilderBase < Minitest::Test
  include SchemaPath
  include ShippingOptions

  def test_validates_expected_insurrance
    @builder_base = UPS::Builders::BuilderBase.new('my_std_root') do |builder|
      builder.add_package package_with_insurance
    end
    assert_equal expected_package, @builder_base.to_xml
  end

  def test_validates_expected_raise_incomplete_insurrance
    assert_raises UPS::Tools::InvalidOptsParams do
      @builder_base = UPS::Builders::BuilderBase.new('my_std_root') do |builder|
        builder.add_package package_with_insurance_incomplete
      end
      @builder_base.to_xml
    end
  end

  def test_work_without_description
      @builder_base = UPS::Builders::BuilderBase.new('my_std_root') do |builder|
        builder.add_package package_insurance_without_descr
      end
      assert_equal expected_without_descr_package, @builder_base.to_xml
  end

  def expected_package
    File.open('spec/support/expected_package.xml','rb', &:read)
  end

  def expected_without_descr_package
    File.open('spec/support/insurance_without_descr.xml','rb', &:read)
  end
end
