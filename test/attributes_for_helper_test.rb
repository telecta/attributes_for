require "test_helper"

class AttributesFor::Rails::AttributesForHelperTest < ActionView::TestCase

  def object
    @o ||= Struct.new(
      :id, :name, :phone, :fax, :email, :website, :duration, :active, :created_at
    ) do

      def self.human_attribute_name(attribute)
        I18n.t("activerecord.attributes.project.#{attribute}")
      end

    end.new(
      1, "Project 1", "4723232323", nil, "name@example.com",
      "http://example.com", 123456, true, DateTime.now
     )
  end

  def with_concat_attributes_for(*args, &block)
    concat attributes_for(*args, &block)
  end

  def store_translations(locale, translations, &block)
    I18n.backend.store_translations locale, translations
    yield
  ensure
    I18n.reload!
    I18n.backend.send :init_translations
  end

  test "#attribute renders a label followed by value of the object attribute" do
    store_translations(:en, activerecord: {attributes: {project: {name: "Name"}}}) do
      with_concat_attributes_for(object) { |b| b.attribute(:name) }
    end

    assert_select "i[id=\"name\"]", text: "Name: #{object.name}"
  end

  test "#attribute renders 'Not set' if the attribute is nil" do
    store_translations(:en,
      activerecord: {attributes: {project: {fax: "Fax"}}},
      attributes_for: {not_set: "Not set" }
    ) do
      with_concat_attributes_for(object) { |b| b.attribute(:fax) }
    end

    assert_select "i[id=\"fax\"]", text: "Fax: Not set"
  end

  test "#attribute renders 'Not set' if the attributes is an empty string" do
    store_translations(:en,
      activerecord: {attributes: {project: {fax: "Fax"}}},
      attributes_for: {not_set: "Not set" }
    ) do
      object.fax = ""
      with_concat_attributes_for(object) { |b| b.attribute(:fax) }
    end

    assert_select "i[id=\"fax\"]", text: "Fax: Not set"
  end

  test "#attribute called with a block uses the block as content" do
    store_translations(:en, activerecord: {attributes: {project: {name: "Name"}}}) do
      with_concat_attributes_for(object) { |b| b.attribute(:name) { "New Content" } }
    end
    assert_select "i[id=\"name\"]", text: "Name: New Content"
  end

  test "#boolean renders 'Yes' or 'No'" do
    store_translations(:en,
      attributes_for: {"true" => "Yes"},
      activerecord: {attributes: {project: {active: "Active"}}}
    ) do
      with_concat_attributes_for(object) { |b| b.boolean(:active) }
    end
    assert_select "i[id=\"active\"][class=\"fa fa-check\"]", text: "Active: Yes"
  end

  test "#phone renders a phone link" do
    store_translations(:en, activerecord: {attributes: {project: {phone: "Phone"}}}) do
      with_concat_attributes_for(object) { |b| b.phone(:phone) }
    end

    assert_select "i[id=\"phone\"][class=\"fa fa-phone\"]", text: "Phone: +47 23 23 23 23" do |element|
      assert_select element, "a[title=\"Phone\"][href=\"tel:+4723232323\"]"
    end
  end

  test "#date renders date or datetime" do
    store_translations(:en, activerecord: {attributes: {project: {created_at: "Created At"}}}) do
      with_concat_attributes_for(object) { |b| b.date(:created_at) }
    end
    assert_select "i[id=\"created_at\"][class=\"fa fa-calendar\"]", text: "Created At: #{I18n.l(object.created_at)}"
  end

  test "#email renders a email link" do
    store_translations(:en, activerecord: {attributes: {project: {email: "Email"}}}) do
      with_concat_attributes_for(object) { |b| b.email(:email) }
    end
    assert_select "i[id=\"email\"][class=\"fa fa-envelope\"]", text: "Email: name@example.com" do |element|
      assert_select element, "a[title=\"Email\"][href=\"mailto:name@example.com\"]"
    end
  end

  test "#duration renders an integer in human readable form" do
    store_translations(:en, activerecord: {attributes: {project: {duration: "Duration"}}}) do
      with_concat_attributes_for(object) { |b| b.duration(:duration) }
    end
    assert_select "i[id=\"duration\"][class=\"fa fa-clock-o\"]", text: "Duration: 1 day 10 hrs 17 mins 36 secs"
  end

  test "#duration renders '0 secs' when integer is zero or not set" do
    store_translations(:en, activerecord: {attributes: {project: {duration: "Duration"}}}) do
      object.duration = 0
      with_concat_attributes_for(object) { |b| b.duration(:duration) }
    end
    assert_select "i[id=\"duration\"][class=\"fa fa-clock-o\"]", text: "Duration: 0 secs"
  end

  test "#string renders a string with content" do
    with_concat_attributes_for(object) do |b|
      b.string("String", id: "new_id", class: "custom") do
        "Content"
      end
    end
    assert_select "i[id=\"new_id\"][class=\"custom\"]", text: "String: Content"
  end

  test "#url renders a link" do
    store_translations(:en, activerecord: {attributes: {project: {website: "Website"}}}) do
      with_concat_attributes_for(object) { |b| b.url(:website) }
    end
    assert_select "i[id=\"website\"][class=\"fa fa-globe\"]", text: "Website: http://example.com" do |element|
      assert_select element, "a[title=\"Website\"][href=\"http://example.com\"]"
    end
  end

  test "options[:label] set to false, renders without label" do
    store_translations(:en, activerecord: {attributes: {project: {website: "Website"}}}) do
      with_concat_attributes_for(object) { |b| b.attribute(:name, label: false) }
    end
    assert_select "i", text: "Project 1"
  end

  test "options[:class] set to 'new_id', renders element with custom id" do
    with_concat_attributes_for(object) { |b| b.attribute(:name, id: "new_id") }
    assert_select "i[id=\"new_id\"]"
  end

  test "options[:class] set to 'fa fa-user' renders element with given class(es)" do
    with_concat_attributes_for(object) { |b| b.attribute(:name, class: 'fa fa-user') }
    assert_select "i[class=\"fa fa-user\"]"
  end
end
