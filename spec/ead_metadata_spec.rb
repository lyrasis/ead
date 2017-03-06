require "spec_helper"
require "securerandom"

describe "EAD Metadata" do

  before(:all) do
    @ead = EAD::Metadata.new
  end

  after(:all) do
    # $stdout.puts "\n#{@ead.to_ead_xml}"
  end

  describe "ead" do

    xit "creates a basic default record" do
      # TODO
    end

  end

  describe "eadheader" do

    let(:title) { "titleproper" }
    let(:title_terms) { [:eadheader, :filedesc, :titlestmt, :titleproper] }
    
    let(:publisher) { "publisher" }
    let(:publisher_terms) { [:eadheader, :filedesc, :publicationstmt, :publisher] }

    let(:address) {
      [
        '123456 Street',
        'P.O. Box 987654',
        'Sometown, ZZ 12345-1234',
        'someone@email.edu',
        'URL: ',
      ]
    }
    let(:url) { "https://www.somewhere.edu" }
    let(:url_terms) { [:eadheader, :filedesc, :publicationstmt, :address, :addressline, :extptr] }

    let(:creation) { "This finding aid was produced using ArchivesSpace on " }
    let(:creation_terms) { [:eadheader, :profiledesc, :creation ] }
    let(:date) { "2017-01-09 19:04:01 -0500" }

    it "can assign titleproper" do 
      path = @ead.eadheader.filedesc.titlestmt
      expect {
        assign(path, :titleproper, "#{title} ")
        assign(path.titleproper, :num, '1')
        assign(@ead.title, :num, '2')
      }.to_not raise_error

      expect(@ead.term_values(*title_terms)[0]).to match(title)
    end

    it "can assign publisher" do
      path = @ead.eadheader.filedesc.publicationstmt
      expect {
        assign(path, :publisher, publisher)
      }.to_not raise_error

      expect(@ead.term_values(*publisher_terms)[0]).to eq(publisher)
    end

    it "can assign address and extptr" do
      path       = @ead.eadheader.filedesc.publicationstmt.address
      last_index = address.length - 1
      expect {
        assign(path, :addressline, address)
        path = path.addressline(last_index)
        assign(path.extptr, :xlink_href, url)
        assign(path.extptr, :xlink_show, "new")
        assign(path.extptr, :xlink_title, url)
        assign(path.extptr, :xlink_type, "simple")
      }.to_not raise_error

      expect(@ead.term_values(*url_terms)[0]).to eq("") # values in attrs
    end

    it "can assign creation with date and descrules" do
      path = @ead.eadheader.profiledesc
      expect {
        assign(path, :creation, creation)
        assign(path.creation, :date, date)
      }.to_not raise_error

      expect(@ead.term_values(*creation_terms)[0]).to match(creation)
    end

  end

  describe "archdesc" do

    let(:language) { "English" }
    let(:langcode) { "eng" }

     it "can assign language and langcode" do
      path = @ead.archdesc.did.langmaterial
      expect {
        path.language = language
        path.language.langcode = langcode
      }.to_not raise_error
    end   

  end

  describe "dsc" do

    describe "c01" do

      it "can initialize a c01 component tree" do
        (0..1).each do |idx|
          if @ead.archdesc.dsc.c01.count == 0
            @ead.archdesc.dsc.c01.id = SecureRandom.hex
          else
            @ead.archdesc.dsc.c01(idx).id = SecureRandom.hex
          end
        end
      end

      let(:data) {
        {
          c01_1: {
            title: "1st c01 title!"
          },
          c01_2: {
            title: "2nd c01 title!"
          }, 
        }
      }

      it "assigns data for the 1st c01 component" do
        path = @ead.archdesc.dsc.c01(0)
        assign(path.did, :unittitle, data[:c01_1][:title])
      end

      it "assigns data for the 2nd c01 component" do
        path = @ead.archdesc.dsc.c01(1)
        assign(path.did, :unittitle, data[:c01_2][:title])
      end

      describe "c02" do

        it "can initialize a c02 component tree" do
          (0..1).each do |idx|
            if @ead.archdesc.dsc.c01(0).c02.count == 0
              @ead.archdesc.dsc.c01(0).c02.id = SecureRandom.hex
              @ead.archdesc.dsc.c01(1).c02.id = SecureRandom.hex
            else
              @ead.archdesc.dsc.c01(0).c02(idx).id = SecureRandom.hex
              @ead.archdesc.dsc.c01(1).c02(idx).id = SecureRandom.hex
            end
          end
        end

        let(:data) {
          {
            c01_1: {
              c02_1: {
                title: "c01_1 c02_1 title!"
              },
              c02_2: {
                title: "c01_1 c02_2 title!"
              },
            },
            c01_2: {
              c02_1: {
                title: "c01_2 c02_1 title!"
              },
              c02_2: {
                title: "c01_2 c02_2 title!"
              },
            },
          }
        }
        
        it "assigns data for the 1st c02 component of 1st c01" do
          path = @ead.archdesc.dsc.c01(0).c02(0)
          expect{
            assign(path.did, :unittitle, data[:c01_1][:c02_1][:title])
          }.to_not raise_error
        end

        it "assigns data for the 2nd c02 component of 1st c01" do
          path = @ead.archdesc.dsc.c01(0).c02(1)
          expect{
            assign(path.did, :unittitle, data[:c01_1][:c02_2][:title])
          }.to_not raise_error
        end

        it "assigns data for the 1st c02 component of 2nd c01" do
          path = @ead.archdesc.dsc.c01(1).c02(0)
          expect{
            assign(path.did, :unittitle, data[:c01_2][:c02_1][:title])
          }.to_not raise_error
        end

        it "assigns data for the 2nd c02 component of 2nd c01" do
          path = @ead.archdesc.dsc.c01(1).c02(1)
          expect{
            assign(path.did, :unittitle, data[:c01_2][:c02_2][:title])
          }.to_not raise_error
        end

        describe "c03" do

          it "can initialize a c03 component tree" do
            (0..1).each do |idx|
              if @ead.archdesc.dsc.c01(0).c02(0).c03.count == 0
                @ead.archdesc.dsc.c01(0).c02(0).c03.id = SecureRandom.hex
                @ead.archdesc.dsc.c01(0).c02(1).c03.id = SecureRandom.hex
              else
                @ead.archdesc.dsc.c01(0).c02(0).c03(idx).id = SecureRandom.hex
                @ead.archdesc.dsc.c01(0).c02(1).c03(idx).id = SecureRandom.hex
              end
            end
          end

        end

      end

    end

  end

end