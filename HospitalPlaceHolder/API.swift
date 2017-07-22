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

public final class LoginUserByFacebookIdQuery: GraphQLQuery {
  public static let operationDefinition =
    "query loginUserByFacebookId($facebookId: String!) {" +
    "  allUsers(filter: {facebookId_in: [$facebookId]}) {" +
    "    __typename" +
    "    ...UserDetails" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(UserDetails.fragmentDefinition)

  public let facebookId: String

  public init(facebookId: String) {
    self.facebookId = facebookId
  }

  public var variables: GraphQLMap? {
    return ["facebookId": facebookId]
  }

  public struct Data: GraphQLMappable {
    public let allUsers: [AllUser]

    public init(reader: GraphQLResultReader) throws {
      allUsers = try reader.list(for: Field(responseName: "allUsers", arguments: ["filter": ["facebookId_in": [reader.variables["facebookId"]]]]))
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

public final class UserByQuery: GraphQLQuery {
  public static let operationDefinition =
    "query UserBy($username: String!) {" +
    "  allUsers(filter: {username_in: [$username]}) {" +
    "    __typename" +
    "    ...UserDetails" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(UserDetails.fragmentDefinition)

  public let username: String

  public init(username: String) {
    self.username = username
  }

  public var variables: GraphQLMap? {
    return ["username": username]
  }

  public struct Data: GraphQLMappable {
    public let allUsers: [AllUser]

    public init(reader: GraphQLResultReader) throws {
      allUsers = try reader.list(for: Field(responseName: "allUsers", arguments: ["filter": ["username_in": [reader.variables["username"]]]]))
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

public final class RegisterUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation RegisterUser($username: String!, $password: String!, $userType: Int!) {" +
    "  createUser(username: $username, name: $username, password: $password, facebookId: \"000\", userType: $userType, url: \"\") {" +
    "    __typename" +
    "    ...UserDetails" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(UserDetails.fragmentDefinition)

  public let username: String
  public let password: String
  public let userType: Int

  public init(username: String, password: String, userType: Int) {
    self.username = username
    self.password = password
    self.userType = userType
  }

  public var variables: GraphQLMap? {
    return ["username": username, "password": password, "userType": userType]
  }

  public struct Data: GraphQLMappable {
    public let createUser: CreateUser?

    public init(reader: GraphQLResultReader) throws {
      createUser = try reader.optionalValue(for: Field(responseName: "createUser", arguments: ["username": reader.variables["username"], "name": reader.variables["username"], "password": reader.variables["password"], "facebookId": "000", "userType": reader.variables["userType"], "url": ""]))
    }

    public struct CreateUser: GraphQLMappable {
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

public final class RegisterUserByFacebookMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation RegisterUserByFacebook($username: String!, $name: String!, $facebookId: String!, $url: String) {" +
    "  createUser(username: $username, name: $name, password: \"00000000\", facebookId: $facebookId, userType: 2, url: $url) {" +
    "    __typename" +
    "    ...UserDetails" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(UserDetails.fragmentDefinition)

  public let username: String
  public let name: String
  public let facebookId: String
  public let url: String?

  public init(username: String, name: String, facebookId: String, url: String? = nil) {
    self.username = username
    self.name = name
    self.facebookId = facebookId
    self.url = url
  }

  public var variables: GraphQLMap? {
    return ["username": username, "name": name, "facebookId": facebookId, "url": url]
  }

  public struct Data: GraphQLMappable {
    public let createUser: CreateUser?

    public init(reader: GraphQLResultReader) throws {
      createUser = try reader.optionalValue(for: Field(responseName: "createUser", arguments: ["username": reader.variables["username"], "name": reader.variables["name"], "password": "00000000", "facebookId": reader.variables["facebookId"], "userType": 2, "url": reader.variables["url"]]))
    }

    public struct CreateUser: GraphQLMappable {
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

public struct UserDetails: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment UserDetails on User {" +
    "  __typename" +
    "  id" +
    "  name" +
    "  username" +
    "  userType" +
    "  url" +
    "  facebookId" +
    "}"

  public static let possibleTypes = ["User"]

  public let __typename: String
  public let id: GraphQLID
  public let name: String
  public let username: String
  public let userType: Int
  public let url: String?
  public let facebookId: String

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    name = try reader.value(for: Field(responseName: "name"))
    username = try reader.value(for: Field(responseName: "username"))
    userType = try reader.value(for: Field(responseName: "userType"))
    url = try reader.optionalValue(for: Field(responseName: "url"))
    facebookId = try reader.value(for: Field(responseName: "facebookId"))
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
    "  address" +
    "  labsValue" +
    "  outcome" +
    "  treatments" +
    "}"

  public static let possibleTypes = ["Disease"]

  public let __typename: String
  public let id: GraphQLID
  public let name: String
  public let lat: Double
  public let long: Double
  public let symptoms: String
  public let address: String?
  public let labsValue: String?
  public let outcome: String?
  public let treatments: String?

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    name = try reader.value(for: Field(responseName: "name"))
    lat = try reader.value(for: Field(responseName: "lat"))
    long = try reader.value(for: Field(responseName: "long"))
    symptoms = try reader.value(for: Field(responseName: "symptoms"))
    address = try reader.optionalValue(for: Field(responseName: "address"))
    labsValue = try reader.optionalValue(for: Field(responseName: "labsValue"))
    outcome = try reader.optionalValue(for: Field(responseName: "outcome"))
    treatments = try reader.optionalValue(for: Field(responseName: "treatments"))
  }
}