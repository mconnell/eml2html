require "spec_helper"

RSpec.describe HtmlExtractor do
  subject { described_class.new(eml_string) }

  describe "#call" do
    context "plain text only .eml" do
      let(:eml_string) do
        <<~EML
        Content-Type: text/plain

        Did you know that wearing a tie can reduce blood flow to the brain
        by 7.5%

        EML
      end

      it "returns nothing because that's what you deserve for asking an HTML extractor" do
        expect(subject.call).to eq(nil)
      end
    end

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

    context " ASCII-8BIT encoded .eml" do
      let(:eml_string) do
        <<~EML
        Content-Type: text/html; charset="Windows-1252"
        Content-Transfer-Encoding: quoted-printable

        <h1>
          =A92025
        </h1>
        EML
      end

      it "returns the HTML portion but with characters correct" do
        expect(subject.call).to eq(
          <<~HTML
            <h1>
              ©2025
            </h1>
          HTML
        )
      end
    end

    context "French .eml" do
      let(:eml_string) do
        <<~EML
        Content-Transfer-Encoding: quoted-printable
        Content-Type: text/html; charset=utf-8
        Mime-Version: 1.0

        <h1>
          Comparez facilement bus, train et covoit=E2=80=99 p=our
          trouver le voyage qui correspond =C3=A0 vos plans.
          Au volant ? Vous d==C3=A9cidez de tout : itin=C3=A9raire,
          horaire et prix.
        </h1>
        EML
      end

      it "returns the HTML portion but doesn't stomp on accented characters" do
        expect(subject.call).to eq(
          <<~HTML
            <h1>
              Comparez facilement bus, train et covoit’ p=our
              trouver le voyage qui correspond =C3=A0 vos plans.
              Au volant ? Vous d==C3=A9cidez de tout : itin=C3=A9raire,
              horaire et prix.
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
