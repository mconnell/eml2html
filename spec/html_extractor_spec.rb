require "spec_helper"

RSpec.describe HtmlExtractor do
  subject { described_class.new(eml_string) }

  describe "#call" do
    context "simple HTML only .eml" do
      let(:eml_string) do
        <<~EML
        Content-Type: text/html

        <h1>
          How now brown cow
        </h1>
        EML
      end

      it "returns the HTML portion" do
        expect(subject.call).to eq(
          <<~HTML
            <h1>
              How now brown cow
            </h1>
          HTML
        )
      end
    end

    context "multipart eml file" do
      let(:eml_string) do
        <<~EML
        Content-Type: multipart/alternative; boundary="alt"

        --alt
        Content-Type: text/plain

        Hello, I'm the plain text version of the email!

        --alt
        Content-Type: text/html

        <p>
          Hello, I'm the HTML version of the email!
        </p>

        --alt--
        EML
      end

      it "returns the HTML portion" do
        expect(subject.call).to eq(
          <<~HTML
          <p>
            Hello, I'm the HTML version of the email!
          </p>
          HTML
        )
      end
    end
  end
end
