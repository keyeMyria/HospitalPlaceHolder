//
//  StringExtension.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/24/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import Foundation

extension String{
    func localized() ->String {
        let ud = UserDefaults.standard
        var deviceLanguage = ud.object(forKey: "app_language")
        
        if deviceLanguage == nil {
            deviceLanguage = "vi"
        }
        
        let path = Bundle.main.path(forResource: deviceLanguage as? String, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
