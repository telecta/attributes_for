require "spec_helper"

describe AttributesFor::AttributesForHelper do

  describe AttributesFor::AttributesForHelper::AttributeBuilder do

    let(:object) do
      Company.new(1, "Evil Corp", "+4723232323", nil, "name@example.com",
        "http://example.com", 123456, true, DateTime.now
      )
    end

    before do
      store_translations(:en, activerecord: {
        attributes: {
          company: {
            name: "Name",
            phone: "Phone",
            fax: "Fax",
            email: "Email",
            website: "Website",
            duration: "Duration",
            active: "Active",
            created_at: "Created At"
          },
      }}, attributes_for: {
            not_set: "Not set",
            "true" => "Yes",
      })
    end

    describe "#attribute" do
      it "renders an attribute" do
        expect(builder(object).attribute(:name)).to eq(
          "<i id=\"name\"> Name: #{object.name}</i>"
        )
      end

      context "when content is empty string or nil" do
        it "outputs 'not_set' translation" do
          expect(builder(object).attribute(:fax)).to eq(
            "<i id=\"fax\"> Fax: Not set</i>"
          )

          object.fax = ""
          expect(builder(object).attribute(:fax)).to eq(
            "<i id=\"fax\"> Fax: Not set</i>"
          )
        end
      end

      context "when called with block" do
        it "uses the block as content" do
          expect(builder(object).attribute(:name) do
            "New Content"
          end).to eq(
            "<i id=\"name\"> Name: New Content</i>"
          )
        end
      end
    end

    describe "#boolean" do
      it "renders 'Yes' or 'No'" do
        expect(builder(object).boolean(:active)).to eq(
          "<i id=\"active\" class=\"fa fa-check\"> Active: Yes</i>"
        )
      end

      context "when called with block" do
        it "uses the block as content" do
          expect(builder(object).boolean(:active) do
            "New Content"
          end).to eq(
            "<i id=\"active\" class=\"fa fa-check\"> Active: New Content</i>"
          )
        end
      end
    end

    describe "#phone" do
      it "renders a phone link" do
        expect(builder(object).phone(:phone)).to eq(
          "<i id=\"phone\" class=\"fa fa-phone\"> Phone: " +
          "<a title=\"Phone\" href=\"tel:+4723232323\"> +472-323-2323</a>" +
          "</i>"
        )
      end

      context "when called with block" do
        it "uses the block as content" do
          expect(builder(object).phone(:phone) do
            "New Content"
          end).to eq(
            "<i id=\"phone\" class=\"fa fa-phone\"> Phone: New Content</i>"
          )
        end
      end
    end

    describe "#email" do
      it "renders an email link" do
        expect(builder(object).email(:email)).to eq(
          "<i id=\"email\" class=\"fa fa-envelope\"> Email: " +
          "<a title=\"Email\" href=\"mailto: name@example.com\">name@example.com</a>" +
          "</i>"
        )
      end

      context "when email not present" do
        it "does not render the link" do
          object.email = nil
          expect(builder(object).email(:email)).to eq(
            "<i id=\"email\" class=\"fa fa-envelope\"> Email: Not set</i>"
          )
        end
      end

      context "when called with block" do
        it "uses the block as content" do
          expect(builder(object).email(:email) do
            "New Content"
          end).to eq(
            "<i id=\"email\" class=\"fa fa-envelope\"> Email: New Content</i>"
          )
        end
      end
    end

    describe "#duration" do
      it "renders an integer as days, hours, minutes and seconds" do
        expect(builder(object).duration(:duration)).to eq(
          "<i id=\"duration\" class=\"fa fa-clock-o\"> Duration: 1 day 10 hrs 17 mins 36 secs</i>"
        )
      end
    end

    describe "#url" do
      it "renders a link" do
        expect(builder(object).url(:website)).to eq(
          "<i id=\"website\" class=\"fa fa-globe\"> Website: " +
          "<a title=\"Website\" href=\"http://example.com\"> http://example.com</a>" +
          "</i>"
        )
      end

      context "when called with block" do
        it "uses the block as content" do
          expect(builder(object).url(:website) do
            "New Content"
          end).to eq(
            "<i id=\"website\" class=\"fa fa-globe\"> Website: New Content</i>"
          )
        end
      end
    end

    describe "#date" do
      it "renders a time, date or datetime" do
        expect(builder(object).date(:created_at)).to eq(
          "<i id=\"created_at\" class=\"fa fa-calendar\"> Created At: #{I18n.l(object.created_at)}</i>"
        )
      end

      context "when called with block" do
        it "uses the block as content" do
          expect(builder(object).date(:created_at) do
            "New Content"
          end).to eq(
            "<i id=\"created_at\" class=\"fa fa-calendar\"> Created At: New Content</i>"
          )
        end
      end
    end

    describe "options" do
      describe "css" do
        it "uses the css given" do
          expect(builder(object).attribute(:name, class: "fa fa-user")).to eq(
            "<i id=\"name\" class=\"fa fa-user\"> Name: #{object.name}</i>"
          )
        end
      end

      describe "label" do
        context "when false" do
          it "renders without label" do
            expect(builder(object).phone(:phone, label: false)).to eq(
              "<i id=\"phone\" class=\"fa fa-phone\"> " +
              "<a title=\"Phone\" href=\"tel:+4723232323\"> +472-323-2323</a>" +
              "</i>"
            )
          end
        end
      end

      describe "id" do
        it "sets the dom id" do
          expect(builder(object).attribute(:name, id: :new_id)).to eq(
            "<i id=\"new_id\"> Name: #{object.name}</i>"
          )
        end
      end

    end

    describe "translations" do
      it "translates the label" do
        store_translations(:en, activerecord: {attributes: {company: {name: "Navn"}}})
        expect(builder(object).attribute(:name)).to eq(
          "<i id=\"name\"> Navn: #{object.name}</i>"
        )
      end
    end

    def builder(object, options = {})
      @builder = AttributesFor::AttributesForHelper::AttributeBuilder.new(object, ActionView::Base.new)
    end

  end

  def store_translations(locale, translations)
    I18n.backend.store_translations locale, translations
  end

end
