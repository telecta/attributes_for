require "test_helper"

class AttributesFor::Rails::AttributesForHelperTest < ActionView::TestCase

  test "attributes_for options[:defaults] renders all attribute with default options" do
    expected = "<span class=\"label\">Name:</span> <span>Project 1</span>"
    assert_attributes_for(expected, object, defaults: { label_html: { class: 'label' }}) do |b|
      b.attribute :name
    end
  end

  test "attributes_for options[:wrappers][:label] renders with given label wrapper tag" do
    expected = '<strong>Name:</strong> <span>Project 1</span>'
    assert_attributes_for(expected, object, wrappers: { label: 'strong' }) do |b|
      b.attribute :name
    end
  end

  test "attributes_for options[:wrappers][:value] renders with given value wrapper tag" do
    expected = '<span>Name:</span> <strong>Project 1</strong>'
    assert_attributes_for(expected, object, wrappers: { value: 'strong' }) do |b|
      b.attribute :name
    end
  end

  test "attributes_for options[:label_html] renders the label with the given options" do
    expected = '<span class="label label-default">Name:</span> <span>Project 1</span>'
    assert_attributes_for(expected, object) do |b|
      b.attribute :name, label_html: { class: 'label label-default' }
    end
  end

  test "#attribute renders a label followed by value of the object attribute" do
    expected = "<span>Name:</span> <span>Project 1</span>"
    assert_attributes_for(expected, object) do |b|
      b.attribute :name
    end
  end

  test "#attribute render an integer" do
    expected = "<span>Billing Frequency:</span> <span>15</span>"
    assert_attributes_for(expected, object) do |b|
      b.attribute :billing_frequency
    end
  end

  test "#attribute renders 'Not set' if the attribute is nil" do
    store_translations(:en, attributes_for: {not_set: "Not set" }) do
      expected = "<span>Fax:</span> <span>Not set</span>"
      assert_attributes_for(expected, object) do |b|
        b.attribute :fax
      end
    end
  end

  test "#attribute renders 'Not set' if the attributes is an empty string" do
    store_translations(:en, attributes_for: {not_set: "Not set" }) do
      expected = "<span>Fax:</span> <span>Not set</span>"
      assert_attributes_for(expected, object.tap {|o| o.fax = ""}) do |b|
        b.attribute :fax
      end
    end
  end

  test "#attribute called with a block uses the block as content" do
    expected = "<span>Name:</span> <span>New Content</span>"
    assert_attributes_for(expected, object) do |b|
      b.attribute(:name) { "New Content" }
    end
  end

  test "#attribute translates the label" do
    store_translations(:en, activerecord: {attributes: {project: {name: "Nome"}}}) do
      expected = "<span>Nome:</span> <span>Project 1</span>"
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
      expected = "<i class=\"fa fa-check\"></i> <span>Active:</span> <span>Yes</span>"
      assert_attributes_for(expected, object) do |b|
        b.boolean :active
      end
    end
  end

  test "#phone renders a phone link" do
    expected = "<i class=\"fa fa-phone\"></i> <span>Phone:</span> <span><a title=\"Phone\" href=\"tel:+47 23 23 23 23\">+47 23 23 23 23</a></span>"
    assert_attributes_for(expected, object) do |b|
      b.phone :phone
    end
  end

  test "#date renders date for date" do
    expected = "<i class=\"fa fa-calendar\"></i> <span>Due On:</span> <span>2001-01-01</span>"
    assert_attributes_for(expected, object) do |b|
      b.date :due_on
    end
  end

  test "#date renders only date for datetime" do
    expected = "<i class=\"fa fa-calendar\"></i> <span>Created At:</span> <span>2001-01-01</span>"
    assert_attributes_for(expected, object) do |b|
      b.date :created_at
    end
  end

  test "#datetime renders datetime" do
    expected = "<i class=\"fa fa-calendar\"></i> <span>Created At:</span> <span>Mon, 01 Jan 2001 00:00:00 +0000</span>"
    assert_attributes_for(expected, object) do |b|
      b.datetime :created_at
    end
  end

  test "#email renders a email link" do
    expected = "<i class=\"fa fa-envelope\"></i> <span>Email:</span> <span><a title=\"Email\" href=\"mailto:name@example.com\">name@example.com</a></span>"
    assert_attributes_for(expected, object) do |b|
      b.email :email
    end
  end

  test "#duration renders an integer in human readable form" do
    expected = "<i class=\"fa fa-clock-o\"></i> <span>Duration:</span> <span>1 day 10 hrs 17 mins 36 secs</span>"
    assert_attributes_for(expected, object) do |b|
      b.duration :duration
    end
  end

  test "#duration renders '0 secs' when integer is zero or not set" do
    expected = "<i class=\"fa fa-clock-o\"></i> <span>Duration:</span> <span>0 secs</span>"
    assert_attributes_for(expected, object.tap {|o| o.duration = 0}) do |b|
      b.duration :duration
    end
  end

  test "#string renders a string with content" do
    expected = "<span id=\"new_id\" class=\"custom\">String:</span> <span>Content</span>"
    assert_attributes_for(expected, object) do |b|
      b.string("String", label_html: { id: 'new_id', class: 'custom' }) do
        "Content"
      end
    end
  end

  test "#url renders a link" do
    expected = "<i class=\"fa fa-globe\"></i> <span>Website:</span> <span><a title=\"Website\" href=\"http://example.com\">http://example.com</a></span>"
    assert_attributes_for(expected, object) do |b|
      b.url :website
    end
  end

  test "#attribute options[:label] set to false, renders without label" do
    expected = "Project 1"
    assert_attributes_for(expected, object) do |b|
      b.attribute :name, label: false
    end
  end

  test "#attribute options[:icon] set to 'users' renders element with the given icon" do
    expected = "<i class=\"fa fa-users\"></i> <span>Name:</span> <span>Project 1</span>"
    assert_attributes_for(expected, object) do |b|
      b.attribute :name, icon: "users"
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
