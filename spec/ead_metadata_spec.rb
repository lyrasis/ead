require "spec_helper"
require "securerandom"

describe "EAD Metadata" do

  before(:all) do
    @ead = EAD::Metadata.new
  end

  after(:all) do
    $stdout.puts "\n#{@ead.to_ead_xml}"
  end

  describe "ead" do

    it "creates a basic default record" do
      expect {
        @ead.to_ead_xml
      }.to_not raise_error
    end

  end

  describe "eadheader" do

    let(:title) { "titleproper" }
    let(:title_terms) { [:eadheader, :filedesc, :titlestmt, :titleproper] }
    let(:author) { "Some Author" }

    let(:publisher) { "publisher" }
    let(:publisher_terms) { [:eadheader, :filedesc, :publicationstmt, :publisher] }

    let(:notestmt_terms) { [:eadheader, :filedesc, :notestmt, :note, :p] }

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
      }.to_not raise_error

      expect(@ead.term_values(*title_terms)[0]).to match(title)
    end

    it "can assign filing title" do
      path = @ead.eadheader.filedesc.titlestmt
      expect {
        assign(path, :filing, "#{title} ")
        assign(path.filing, :num, '1')
        assign(path.filing, :audience, 'internal')
      }.to_not raise_error
    end

    it "can assign formal title" do
      path = @ead.eadheader.filedesc.titlestmt
      expect {
        assign(path, :formal, "#{title} ")
        assign(path.formal, :num, '1')
      }.to_not raise_error
    end

    it "can assign author" do
      path = @ead.eadheader.filedesc.titlestmt
      expect {
        assign(path, :author, author)
      }.to_not raise_error
    end

    it "can assign publisher" do
      path = @ead.eadheader.filedesc.publicationstmt
      expect {
        assign(path, :publisher, publisher)
      }.to_not raise_error

      expect(@ead.term_values(*publisher_terms)[0]).to eq(publisher)
    end

    it "can assign note statement with number" do
      path = @ead.eadheader.filedesc.notestmt.note
      expect {
        assign(path, :p, "A note with a num: ")
        assign(path, :type, "bpg")
        assign(path.p, :num, "123")
      }.to_not raise_error

      expect(@ead.term_values(*notestmt_terms)[0]).to eq("A note with a num: 123")
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
    let(:repository) { "Archives" }
    let(:unitid) { "123456" }
    let(:unittitle) { "Papers" }
    let(:persons) {
      [
        { name: "A", role: "ive", source: "lcsh" },
        { name: "B", role: "ivr", source: "lcsh" },
        { name: "C", role: "ivr", source: "lcsh" },
      ]
    }
    let(:corps) {
      [
        { name: "X", role: "pro", source: "lcsh" },
        { name: "Y", role: "pro", source: "lcsh" },
      ]
    }
    let(:originations) {
      [
        { type: "persname", name: "A", role: "ive", source: "lcsh" },
        { type: "persname", name: "B", role: "ivr", source: "lcsh" },
        { type: "persname", name: "C", role: "ivr", source: "lcsh" },
        { type: "corpname", name: "X", role: "pro", source: "lcsh" },
        { type: "corpname", name: "Y", role: "pro", source: "lcsh" },
      ]
    }
    let(:odds) {
      [
        { head: "Summary", p: "Something, something ..." },
        { head: "Publication Date", p: "2000." },
        { head: "Something Else", p: "..." },
      ]
    }
    let(:authorities) {
      [
        { type: "subject", name: "Subject 1", source: "lcsh" },
        { type: "subject", name: "Subject 2", source: "lcsh" },
        { type: "subject", name: "Subject 3", source: "lcsh" },
        { type: "geogname", name: "Geogname", source: "lcsh" },
        { type: "genreform", name: "Genreform", source: "lcsh" },
        { type: "persname", name: "Persname", source: "lcsh" },
        { type: "corpname", name: "Corpname 1", source: "lcsh" },
        { type: "corpname", name: "Corpname 2", source: "lcsh" },
        { type: "corpname", name: "Corpname 3", source: "lcsh" },
        { type: "corpname", name: "Corpname 4", source: "lcsh" },
      ]
    }

     it "can assign language and langcode" do
      path = @ead.archdesc.did.langmaterial
      expect {
        path.language = language
        path.language.langcode = langcode
      }.to_not raise_error
    end

    it "can assign a repository" do
      expect {
        @ead.archdesc.did.repository.corpname = repository
      }.to_not raise_error
    end

    it "can assign a unitid" do
      expect {
        @ead.archdesc.did.unitid = unitid
      }.to_not raise_error
    end

    it "can assign a unittitle" do
      expect {
        @ead.archdesc.did.unittitle = unittitle
      }.to_not raise_error
    end

    it "can assign a unitdate" do
      expect {
        @ead.archdesc.did.unitdate = "2014"
        @ead.archdesc.did.unitdate.normal = "2014"
        @ead.archdesc.did.unitdate.type = "single"
      }.to_not raise_error
    end

    it "can assign originations" do
      originations.each do |o|
        expect {
          pos  = @ead.archdesc.did.origination.count
          if pos == 0
            # initialize first element
            @ead.archdesc.did.origination.label = nil
          end
          # initialize label b4 setting it
          @ead.archdesc.did.origination(pos).label = nil
          @ead.archdesc.did.origination(pos).label = "creator"
          @ead.archdesc.did.origination(pos).send("#{o[:type]}=", o[:name])
          path = @ead.archdesc.did.origination(pos).send(o[:type])
          path.role = o[:role]
          path.source = o[:source]
        }.to_not raise_error
      end
      expect(@ead.archdesc.did.origination.count).to eq(5)
    end

    it "can assign physdesc" do
      expect {
        @ead.archdesc.did.physdesc.altrender = "whole"
        @ead.archdesc.did.physdesc.extent = "3 cassettes"
        @ead.archdesc.did.physdesc.extent.altrender = "materialtype"
      }.to_not raise_error
    end

    it "can add odd =)" do
      odds.each do |o|
        expect {
          pos = @ead.archdesc.odd.count
          if pos == 0
            # initialize first element
            @ead.archdesc.odd.audience = nil
          end
          # initialize attribute before setting
          @ead.archdesc.odd(pos).audience = nil
          @ead.archdesc.odd(pos).audience = "internal"
          @ead.archdesc.odd(pos).head = o[:head]
          @ead.archdesc.odd(pos).p = o[:p]
        }.to_not raise_error
      end
    end

    it "can assign citation" do
      expect {
        @ead.archdesc.prefercite.audience = "internal"
        @ead.archdesc.prefercite.head = "Preferred Citation"
        @ead.archdesc.prefercite.p = "Cite ME!"
      }.to_not raise_error
    end

    it "can assign access restriction" do
      expect {
        @ead.archdesc.accessrestrict.audience = "internal"
        @ead.archdesc.accessrestrict.head = "Access Restriction"
        @ead.archdesc.accessrestrict.p = "Restricted!"
      }.to_not raise_error
    end

    it "can assign use restriction" do
      expect {
        @ead.archdesc.userestrict.audience = "internal"
        @ead.archdesc.userestrict.head = "Use Restriction"
        @ead.archdesc.userestrict.p = "Cannot physically handle!"
      }.to_not raise_error
    end

    it "can assign access biographic / historical information" do
      expect {
        @ead.archdesc.bioghist.audience = "internal"
        @ead.archdesc.bioghist.head = "Historical Summary"
        @ead.archdesc.bioghist.p = "The history ..."
      }.to_not raise_error
    end

    it "can assign related material" do
      expect {
        @ead.archdesc.relatedmaterial.audience = "internal"
        @ead.archdesc.relatedmaterial.head = "Related Archival Materials"
        @ead.archdesc.relatedmaterial.p = "Some stuff!"
      }.to_not raise_error
    end

    it "can assign controlaccess" do
      authorities.each do |a|
        expect {
          # initialize source b4 setting it
          pos = @ead.archdesc.controlaccess.send("#{a[:type]}").count
          if pos == 0
            @ead.archdesc.controlaccess.send("#{a[:type]}=", a[:name])
            @ead.archdesc.controlaccess.send("#{a[:type]}").source = a[:source]
          else
            @ead.archdesc.controlaccess.send(a[:type], pos).source = nil
            @ead.archdesc.controlaccess.send(a[:type], pos).source = a[:source]
            @ead.archdesc.controlaccess.send(a[:type], pos, a[:name])
          end
        }.to_not raise_error
      end
      expect(@ead.archdesc.controlaccess.subject.count).to eq(3)
      expect(@ead.archdesc.controlaccess.corpname.count).to eq(4)
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

      it "can assign containers to c01 component" do
        [
          { id: "1", barcode: "1", number: "1" },
          { id: "2", barcode: "2", number: "2" },
          { id: "3", barcode: "3", number: "3" },
        ].each do |c|
          pos = @ead.archdesc.dsc.c01(0).did.container.count
          if pos == 0
            @ead.archdesc.dsc.c01(0).did.container.id = nil
          end
           # initialize label b4 setting it
          expect {
            @ead.archdesc.dsc.c01(0).did.container(pos).id        = nil
            @ead.archdesc.dsc.c01(0).did.container(pos).id        = c[:id]
            @ead.archdesc.dsc.c01(0).did.container(pos).label     = "Mixed Materials (#{c[:barcode]})"
            @ead.archdesc.dsc.c01(0).did.container(pos).type      = "Box"
            @ead.archdesc.dsc.c01(0).did.container(pos).altrender = "1 cf"
            @ead.archdesc.dsc.c01(0).did.send(:container, pos, c[:number])
          }.to_not raise_error
        end
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