require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  test "limited number of fields per tournament" do
    tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:field, tournament: tournament)

    stub_constant(Field, :LIMIT, 1) do
      field = tournament.fields.build(name: 'new field')
      refute field.valid?
      assert_equal ['Maximum of 1 fields exceeded'], field.errors[:base]
    end
  end

  test "geo json must be valid json" do
    params = FactoryBot.attributes_for(:field, geo_json: 'not json }')
    field = Field.new(params)

    refute field.valid?
    assert_equal ['must be valid JSON'], field.errors[:geo_json]
  end

  test "lat must be number" do
    params = FactoryBot.attributes_for(:field, lat: 'not number')
    field = Field.new(params)

    refute field.valid?
    assert_equal ['is not a number'], field.errors[:lat]
  end

  test "lat must be smaller than 90" do
    params = FactoryBot.attributes_for(:field, lat: 100)
    field = Field.new(params)

    refute field.valid?
    assert_equal ['must be less than or equal to 90'], field.errors[:lat]
  end

  test "lat must be greater than -90" do
    params = FactoryBot.attributes_for(:field, lat: -100)
    field = Field.new(params)

    refute field.valid?
    assert_equal ['must be greater than or equal to -90'], field.errors[:lat]
  end

  test "long must be number" do
    params = FactoryBot.attributes_for(:field, long: 'not number')
    field = Field.new(params)

    refute field.valid?
    assert_equal ['is not a number'], field.errors[:long]
  end

  test "long must be smaller than 180" do
    params = FactoryBot.attributes_for(:field, long: 190)
    field = Field.new(params)

    refute field.valid?
    assert_equal ['must be less than or equal to 180'], field.errors[:long]
  end

  test "long must be greater than -180" do
    params = FactoryBot.attributes_for(:field, long: -190)
    field = Field.new(params)

    refute field.valid?
    assert_equal ['must be greater than or equal to -180'], field.errors[:long]
  end

  test "limit is defined" do
    assert_equal 64, Field::LIMIT
  end
end
