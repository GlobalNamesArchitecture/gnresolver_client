# frozen_string_literal: true

describe GnresolverClient::NameResolvers do
  context "simple search" do
    it "finds results for a name" do
      res = subject.search(
        :get, '{"value":"Hyphessobrycon panamensis daguae", "suppliedId": 1}'
      )
      expect(res).to be_kind_of Array
      expect(res.first.keys.sort).
        to eq %i(matches page perPage suppliedId suppliedNameString total)
      expect(res.first[:matches].size).to be > 1
      expect(res.first[:matches].first.keys.sort).
        to eq %i(canonicalName canonicalNameUuid classificationPath
                 classificationPathIds classificationPathRanks dataSourceId
                 dataSourceTitle matchType nameString nameStringUuid
                 surrogate taxonId vernaculars)
    end

    it "finds results for several names" do
      res = subject.search(
        :get, '[{"value":"Hyphessobrycon panamensis daguae", "suppliedId": 1},
                {"value": "Aegilops", "suppliedId": 2}]'
      )
      expect(res.size).to be 2
      expect(res.last[:total]).to be 3
      expect(res.last[:matches].size).to be 3
      expect(res.last.keys.sort).
        to eq %i(matches page perPage suppliedId suppliedNameString total)
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
