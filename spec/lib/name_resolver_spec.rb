# frozen_string_literal: true

describe GnresolverClient::NameResolvers do
  context "simple search" do
    it "finds results for a name" do
      res = subject.search(
        :get, '{"value":"Hyphessobrycon panamensis daguae", "localId": 1}'
      )
      expect(res).to be_kind_of Array
      expect(res.size).to be > 0
      expect(res.first).to be_kind_of Hash
      expect(res.first.keys.sort).
        to eq %i(localId matches page perPage suppliedNameString total)
      expect(res.first[:matches].first.keys.sort).
        to eq %i(canonicalName canonicalNameUuid classificationPath
                 classificationPathIds classificationPathRanks dataSourceId
                 dataSourceTitle globalId kind nameString nameStringUuid
                 surrogate taxonId vernacular)
    end
  end
end
