//  This file was automatically generated and should not be edited.

import Apollo

public final class CreateDiseaseMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreateDisease($name: String!, $lat: Float!, $long: Float!, $symptoms: String!, $address: String, $labsValue: String, $treatments: String, $outcome: String) {" +
    "  createDisease(name: $name, lat: $lat, long: $long, symptoms: $symptoms, address: $address, labsValue: $labsValue, treatments: $treatments, outcome: $outcome) {" +
    "    __typename" +
    "    id" +
    "  }" +
    "}"

  public let name: String
  public let lat: Double
  public let long: Double
  public let symptoms: String
  public let address: String?
  public let labsValue: String?
  public let treatments: String?
  public let outcome: String?

  public init(name: String, lat: Double, long: Double, symptoms: String, address: String? = nil, labsValue: String? = nil, treatments: String? = nil, outcome: String? = nil) {
    self.name = name
    self.lat = lat
    self.long = long
    self.symptoms = symptoms
    self.address = address
    self.labsValue = labsValue
    self.treatments = treatments
    self.outcome = outcome
  }

  public var variables: GraphQLMap? {
    return ["name": name, "lat": lat, "long": long, "symptoms": symptoms, "address": address, "labsValue": labsValue, "treatments": treatments, "outcome": outcome]
  }

  public struct Data: GraphQLMappable {
    public let createDisease: CreateDisease?

    public init(reader: GraphQLResultReader) throws {
      createDisease = try reader.optionalValue(for: Field(responseName: "createDisease", arguments: ["name": reader.variables["name"], "lat": reader.variables["lat"], "long": reader.variables["long"], "symptoms": reader.variables["symptoms"], "address": reader.variables["address"], "labsValue": reader.variables["labsValue"], "treatments": reader.variables["treatments"], "outcome": reader.variables["outcome"]]))
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

public final class LoginUserQuery: GraphQLQuery {
  public static let operationDefinition =
    "query loginUser($username: String!, $password: String!) {" +
    "  allUsers(filter: {AND: [{username_in: [$username]}, {password_in: [$password]}]}) {" +
    "    __typename" +
    "    ...UserDetails" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(UserDetails.fragmentDefinition)

  public let username: String
  public let password: String

  public init(username: String, password: String) {
    self.username = username
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["username": username, "password": password]
  }

  public struct Data: GraphQLMappable {
    public let allUsers: [AllUser]

    public init(reader: GraphQLResultReader) throws {
      allUsers = try reader.list(for: Field(responseName: "allUsers", arguments: ["filter": ["AND": [["username_in": [reader.variables["username"]]], ["password_in": [reader.variables["password"]]]]]]))
    }

    public struct AllUser: GraphQLMappable {
      public let __typename: String

      public let fragments: Fragments

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))

        let userDetails = try UserDetails(reader: reader)
        fragments = Fragments(userDetails: userDetails)
      }

      public struct Fragments {
        public let userDetails: UserDetails
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

public struct UserDetails: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment UserDetails on User {" +
    "  __typename" +
    "  id" +
    "  name" +
    "  username" +
    "  userType" +
    "  url" +
    "  facebooId" +
    "}"

  public static let possibleTypes = ["User"]

  public let __typename: String
  public let id: GraphQLID
  public let name: String
  public let username: String
  public let userType: Int
  public let url: String?
  public let facebooId: String

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    name = try reader.value(for: Field(responseName: "name"))
    username = try reader.value(for: Field(responseName: "username"))
    userType = try reader.value(for: Field(responseName: "userType"))
    url = try reader.optionalValue(for: Field(responseName: "url"))
    facebooId = try reader.value(for: Field(responseName: "facebooId"))
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
    "  symptoms" +
    "}"

  public static let possibleTypes = ["Disease"]

  public let __typename: String
  public let id: GraphQLID
  public let name: String
  public let lat: Double
  public let long: Double
  public let symptoms: String

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    name = try reader.value(for: Field(responseName: "name"))
    lat = try reader.value(for: Field(responseName: "lat"))
    long = try reader.value(for: Field(responseName: "long"))
    symptoms = try reader.value(for: Field(responseName: "symptoms"))
  }
}