# frozen_string_literal: true

describe GnresolverClient::NameResolvers do
  context "simple search" do
    it "finds results for a name" do
      res = subject.search(
        :get, '{"value":"Hyphessobrycon panamensis daguae", "suppliedId": 1}'
      )
      expect(res).to be_kind_of Hash
      expect(res.keys.sort).to eq %i(data page perPage)
      expect(res[:data]).to be_kind_of Array
      expect(res[:data].first.keys.sort).to eq %i(results suppliedId suppliedInput total)
      expect(res[:data].first[:results].size).to be > 1
      expect(res[:data].first[:results].first.keys.sort).
        to eq %i(canonicalName canonicalNameUuid classificationPath
                 classificationPathIds classificationPathRanks dataSourceId
                 dataSourceTitle globalId localId matchType nameString
                 nameStringUuid prescore surrogate taxonId vernaculars)
    end

    it "finds results for several names" do
      res = subject.search(
        :get, '[{"value":"Hyphessobrycon panamensis daguae", "suppliedId": 1},
                {"value": "Aegilops", "suppliedId": 2}]'
      )
      expect(res[:data].size).to be 2
      expect(res[:data].last[:total]).to be 3
      expect(res[:data].last[:results].size).to be 3
      expect(res.keys.sort).to eq %i(data page perPage)
      expect(res[:data].last.keys.sort).to eq %i(results suppliedId suppliedInput total)
    end
  end

  context "pagination" do
    it "returns pagination as a global parameter" do
      # TODO: Fix #102
      # Currently page and perPage show on the same level as total and
      # localId/suppliedId, but it should come on the root-based "parameters"
      # sections or something like that
    end
  end
end
