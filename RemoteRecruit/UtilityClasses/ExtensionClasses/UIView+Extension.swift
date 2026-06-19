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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func setupNavigationBar(titleText: String) {
        let label = UILabel()
        label.numberOfLines = 1 //increase the number of lines if required
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = titleText
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        let navBar = self.navigationController?.navigationBar
        let barWidth = navBar?.frame.width ?? UIScreen.main.bounds.width
        let barHeight = navBar?.frame.height ?? 44
        
        // Tighter frame: standard height, reduced width for buttons
        label.frame = CGRect(x: 0, y: 0, width: barWidth * 0.6, height: barHeight)  // 60% width leaves room
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.preferredMaxLayoutWidth = barWidth * 0.6
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: barWidth * 0.6),
            label.heightAnchor.constraint(equalToConstant: barHeight)
        ])
        
        self.navigationItem.titleView = label  // Set immediately for layout
        
        // Force layout before animation
        self.view.layoutIfNeeded()
        navBar?.layoutIfNeeded()
        //--
    }
}
