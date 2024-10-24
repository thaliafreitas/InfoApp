//
//  Extension+UIColor.swift
//  Infoday
//
//  Created by Thalia on 24/10/24.
//

import Foundation
import UIKit

extension UIColor {

    @nonobjc class var textColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? .white : .black
            }
        } else {
            // Fallback para versões anteriores ao iOS 13
            return .black
        }
    }

    @nonobjc class var backgroundColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? .black : .white
            }
        } else {
            // Fallback para versões anteriores ao iOS 13
            return .white
        }
    }

}

