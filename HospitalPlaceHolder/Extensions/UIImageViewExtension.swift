//
//  UIImageViewExtension.swift
//  HospitalPlaceHolder
//
//  Created by Dinh Thanh An on 6/25/17.
//  Copyright © 2017 Dinh Thanh An. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UIImageView{
    func loadImageWith(url: URL?, imagePlaceHolder: UIImage) {
        self.image = imagePlaceHolder
    }
}
