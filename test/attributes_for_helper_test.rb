require "test_helper"

class AttributesFor::Rails::AttributesForHelperTest < ActionView::TestCase

  test "#attribute renders a label followed by value of the object attribute" do
    expected = "<span>Name:</span> Project 1"
    assert_attributes_for(expected, object) do |b|
      b.attribute :name
    end
  end

  test "#attribute render an integer" do
    expected = "<span>Billing Frequency:</span> 15"
    assert_attributes_for(expected, object) do |b|
      b.attribute :billing_frequency
    end
  end

  test "#attribute renders 'Not set' if the attribute is nil" do
    store_translations(:en, attributes_for: {not_set: "Not set" }) do
      expected = "<span>Fax:</span> Not set"
      assert_attributes_for(expected, object) do |b|
        b.attribute :fax
      end
    end
  end

  test "#attribute renders 'Not set' if the attributes is an empty string" do
    store_translations(:en, attributes_for: {not_set: "Not set" }) do
      expected = "<span>Fax:</span> Not set"
      assert_attributes_for(expected, object.tap {|o| o.fax = ""}) do |b|
        b.attribute :fax
      end
    end
  end

  test "#attribute called with a block uses the block as content" do
    expected = "<span>Name:</span> New Content"
    assert_attributes_for(expected, object) do |b|
      b.attribute(:name) { "New Content" }
    end
  end

  test "#attribute translates the label" do
    store_translations(:en, activerecord: {attributes: {project: {name: "Nome"}}}) do
      expected = "<span>Nome:</span> Project 1"
      assert_attributes_for(expected, object) do |b|
        b.attribute :name
      end
    end
  end

  test "#boolean renders 'Yes' or 'No'" do
    store_translations(:en,
      attributes_for: {"true" => "Yes"},
      activerecord: {attributes: {project: {active: "Active"}}}
    ) do
      expected = "<i class=\"fa fa-check\"></i> <span>Active:</span> Yes"
      assert_attributes_for(expected, object) do |b|
        b.boolean :active
      end
    end
  end

  test "#phone renders a phone link" do
    expected = "<i class=\"fa fa-phone\"></i> <span>Phone:</span> <a title=\"Phone\" href=\"tel:+47 23 23 23 23\">+47 23 23 23 23</a>"
    assert_attributes_for(expected, object) do |b|
      b.phone :phone
    end
  end

  test "#date renders date for date" do
    expected = "<i class=\"fa fa-calendar\"></i> <span>Due On:</span> 2001-01-01"
    assert_attributes_for(expected, object) do |b|
      b.date :due_on
    end
  end

  test "#date renders only date for datetime" do
    expected = "<i class=\"fa fa-calendar\"></i> <span>Created At:</span> 2001-01-01"
    assert_attributes_for(expected, object) do |b|
      b.date :created_at
    end
  end

  test "#datetime renders datetime" do
    expected = "<i class=\"fa fa-calendar\"></i> <span>Created At:</span> Mon, 01 Jan 2001 00:00:00 +0000"
    assert_attributes_for(expected, object) do |b|
      b.datetime :created_at
    end
  end

  test "#email renders a email link" do
    expected = "<i class=\"fa fa-envelope\"></i> <span>Email:</span> <a title=\"Email\" href=\"mailto:name@example.com\">name@example.com</a>"
    assert_attributes_for(expected, object) do |b|
      b.email :email
    end
  end

  test "#duration renders an integer in human readable form" do
    expected = "<i class=\"fa fa-clock-o\"></i> <span>Duration:</span> 1 day 10 hrs 17 mins 36 secs"
    assert_attributes_for(expected, object) do |b|
      b.duration :duration
    end
  end

  test "#duration renders '0 secs' when integer is zero or not set" do
    expected = "<i class=\"fa fa-clock-o\"></i> <span>Duration:</span> 0 secs"
    assert_attributes_for(expected, object.tap {|o| o.duration = 0}) do |b|
      b.duration :duration
    end
  end

  test "#string renders a string with content" do
    expected = "<span id=\"new_id\" class=\"custom\">String:</span> Content"
    assert_attributes_for(expected, object) do |b|
      b.string("String", id: "new_id", class: "custom") do
        "Content"
      end
    end
  end

  test "#url renders a link" do
    expected = "<i class=\"fa fa-globe\"></i> <span>Website:</span> <a title=\"Website\" href=\"http://example.com\">http://example.com</a>"
    assert_attributes_for(expected, object) do |b|
      b.url :website
    end
  end

  test "options[:label] set to false, renders without label" do
    expected = "Project 1"
    assert_attributes_for(expected, object) do |b|
      b.attribute :name, label: false
    end
  end

  test "options[:id] set to 'new_id', renders element with custom id" do
    expected = "<span id=\"new_id\">Name:</span> Project 1"
    assert_attributes_for(expected, object) do |b|
      b.attribute :name, id: "new_id"
    end
  end

  test "options[:icon] set to 'users' renders element with the given icon" do
    expected = "<i class=\"fa fa-users\"></i> <span>Name:</span> Project 1"
    assert_attributes_for(expected, object) do |b|
      b.attribute :name, icon: "users"
    end
  end

  test "options[:class] set to 'label' renders element with given class(es)" do
    expected = "<span class=\"label\">Name:</span> Project 1"
    assert_attributes_for(expected, object) do |b|
      b.attribute :name, class: 'label'
    end
  end

  private

  def object
    @o ||= Struct.new(
      :id, :name, :phone, :fax, :email, :website, :duration, :active,
      :created_at, :billing_frequency, :due_on
    ) do

      def self.human_attribute_name(attribute, options = {})
        I18n.t("activerecord.attributes.project.#{attribute}", options)
      end

    end.new(
      1, "Project 1", "+4723232323", nil, "name@example.com",
      "http://example.com", 123456, true, DateTime.new(2001, 1, 1),
      15, Date.new(2001, 1, 1)
     )
  end

  def assert_attributes_for(expected, *args, &block)
    assert_dom_equal expected, attributes_for(*args, &block)
  end

  def store_translations(locale, translations, &block)
    I18n.backend.store_translations locale, translations
    yield
  ensure
    I18n.reload!
    I18n.backend.send :init_translations
  end

end
