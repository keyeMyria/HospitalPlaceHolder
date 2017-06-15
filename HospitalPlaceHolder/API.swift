//  This file was automatically generated and should not be edited.

import Apollo

public final class CreateDiseaseMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreateDisease($name: String!, $lat: Float!, $long: Float!, $description: String!) {" +
    "  createDisease(name: $name, lat: $lat, long: $long, description: $description) {" +
    "    __typename" +
    "    id" +
    "  }" +
    "}"

  public let name: String
  public let lat: Double
  public let long: Double
  public let description: String

  public init(name: String, lat: Double, long: Double, description: String) {
    self.name = name
    self.lat = lat
    self.long = long
    self.description = description
  }

  public var variables: GraphQLMap? {
    return ["name": name, "lat": lat, "long": long, "description": description]
  }

  public struct Data: GraphQLMappable {
    public let createDisease: CreateDisease?

    public init(reader: GraphQLResultReader) throws {
      createDisease = try reader.optionalValue(for: Field(responseName: "createDisease", arguments: ["name": reader.variables["name"], "lat": reader.variables["lat"], "long": reader.variables["long"], "description": reader.variables["description"]]))
    }

    public struct CreateDisease: GraphQLMappable {
      public let __typename: String
      public let id: GraphQLID

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        id = try reader.value(for: Field(responseName: "id"))
      }
    }
  }
}

public final class DiseasesByQuery: GraphQLQuery {
  public static let operationDefinition =
    "query DiseasesBy($name: String!) {" +
    "  allDiseases(filter: {name_contains: $name}) {" +
    "    __typename" +
    "    ...DiseaseDetails" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(DiseaseDetails.fragmentDefinition)

  public let name: String

  public init(name: String) {
    self.name = name
  }

  public var variables: GraphQLMap? {
    return ["name": name]
  }

  public struct Data: GraphQLMappable {
    public let allDiseases: [AllDisease]

    public init(reader: GraphQLResultReader) throws {
      allDiseases = try reader.list(for: Field(responseName: "allDiseases", arguments: ["filter": ["name_contains": reader.variables["name"]]]))
    }

    public struct AllDisease: GraphQLMappable {
      public let __typename: String

      public let fragments: Fragments

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))

        let diseaseDetails = try DiseaseDetails(reader: reader)
        fragments = Fragments(diseaseDetails: diseaseDetails)
      }

      public struct Fragments {
        public let diseaseDetails: DiseaseDetails
      }
    }
  }
}

public struct DiseaseDetails: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment DiseaseDetails on Disease {" +
    "  __typename" +
    "  id" +
    "  name" +
    "  lat" +
    "  long" +
    "  description" +
    "}"

  public static let possibleTypes = ["Disease"]

  public let __typename: String
  public let id: GraphQLID
  public let name: String
  public let lat: Double
  public let long: Double
  public let description: String

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    name = try reader.value(for: Field(responseName: "name"))
    lat = try reader.value(for: Field(responseName: "lat"))
    long = try reader.value(for: Field(responseName: "long"))
    description = try reader.value(for: Field(responseName: "description"))
  }
}