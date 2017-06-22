//
//  User.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/22/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var id: String
    var name: String
    var username: String
    var userType: Int
    var url: String?
    var facebookId: String
    
    init(with user: UserDetails) {
        id = user.id
        name = user.name
        username = user.username
        url = user.url
        userType = user.userType
        facebookId = user.facebookId
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        username = aDecoder.decodeObject(forKey: "username") as! String
        userType = aDecoder.decodeInteger(forKey: "userType")
        url = aDecoder.decodeObject(forKey: "url") as? String
        facebookId = aDecoder.decodeObject(forKey: "facebookId") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(userType , forKey: "userType")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(facebookId, forKey: "facebookId")
    }
    
    func saveCurrentUser() {
        let encodedUserObject = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(encodedUserObject, forKey: "KEY_CURRENT_USER")
    }
    
    open class func currentUser() -> User? {
        let encodedUserObject = UserDefaults.standard.object(forKey: "KEY_CURRENT_USER")
        if encodedUserObject == nil {
            return nil
        }
        let user = NSKeyedUnarchiver.unarchiveObject(with: encodedUserObject as! Data)
        
        return user as? User
    }
}
