//
//   Hidekeyboard.swift
//  Search Routes
//
//  Created by Luis Gustavo Oliveira Silva on 05/04/20.
//  Copyright © 2020 Luis Gustavo Oliveira Silva. All rights reserved.
//
import Foundation
import UIKit

extension UIViewController {
    func  hidekeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
