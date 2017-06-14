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