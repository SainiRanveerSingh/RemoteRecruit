//
//  UIView+Extension.swift
//  RemoteRecruit
//
//  Created by RV on 18/06/26.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var isShadow: Bool {
        get {
            return false
        }
        set {
            self.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(10.0))
            self.layer.shadowColor = UIColor.gray.cgColor
            self.layer.shadowRadius = 3
            self.layer.shadowOpacity = 0.25
            self.layer.masksToBounds = false;
            self.clipsToBounds = false;
        }
    }
}
