//
//  APIManager.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/11/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import Foundation
import Apollo

let graphQLEndpoint = "https://api.graph.cool/simple/v1/cj3bpd484nnm20185dmf2tqm6"
let apollo = ApolloClient(url: URL(string: graphQLEndpoint)!)

class APIManager {
    let instance = APIManager()
    
    
}
