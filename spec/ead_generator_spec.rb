require "spec_helper"
require "securerandom"

describe "EAD Generator" do

  before(:all) do
    @ead = EAD::Generator.new
  end

  after(:all) do
    # $stdout.puts "\n#{@ead.to_xml}"
  end

  describe "header" do

    let(:title) { "A title!" }
    let(:address) { ["123 A St.", "Sometown", "CA"] }
    let(:publisher) { "State Archives" }

    it "can set title" do
      @ead.set_title title, 1, " "
      expect(@ead.title).to eq("A title! 1")
    end

    it "can set address" do
      @ead.address = address
      expect(@ead.address.count).to eq(3)
    end

    it "can set publisher" do
      @ead.publisher = publisher
      expect(@ead.publisher).to eq(publisher)
    end

  end

  describe "components" do

    let(:components) {
      {
        'a123' => {
          'b123' => {
            'c123' => {},
            'c456' => {},
            'c555' => {},
          },
          'b456' => {},
          'b111' => {},
        },
        'a456' => {
          'b678' => {
            'c556' => {},
          },
          'b901' => {},
          'b234' => {},
          'b999' => {
            'c124' => {},
            'c457' => {},
            'c557' => {},
            'c777' => {},
            'c888' => {},
            'c999' => {},  
          },
        },
      }
    }

    it "can add c01 components" do
      components.keys.each { |id| @ead.add_c01 id }
      expect(@ead.components.count).to eq 2
      expect(@ead.flat_components.count).to eq 2
    end

    it "can find c01 components by id" do
      components.keys.each { |id| expect(@ead.find_component_by_id(id).id).to eq id }
    end

    it "can assign c01 title" do
      c01 = @ead.find_component_by_id('a456')
      c01.unittitle = "A c01 title!"
      expect(c01.unittitle).to eq ("A c01 title!")
    end

    it "can add c02 components by parent id" do
      components.each do |parent_id, ids|
        ids.keys.each { |id| @ead.add_c02_by_parent_id(parent_id, id) }
      end
      expect(@ead.find_component_by_id('a123').components.count).to eq 3
      expect(@ead.find_component_by_id('a456').components.count).to eq 4
    end

    it "can find c02 components by id" do
      components.values.map { |c| c.keys }.flatten.each { |id| expect(@ead.find_component_by_id(id).id).to eq(id) }
    end

    it "can add c03 components by parent id" do
      components.each do |ancestor_id, parent_ids|
        parent_ids.each do |parent_id, ids|
          ids.keys.each { |id| @ead.add_c03_by_parent_id(parent_id, id) } 
        end
      end
      expect(@ead.find_component_by_id('b123').components.count).to eq 3
      expect(@ead.find_component_by_id('b999').components.count).to eq 6
    end

  end

end