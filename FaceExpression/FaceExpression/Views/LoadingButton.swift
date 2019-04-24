//
//  LoadingButton.swift
//  FaceExpression
//
//  Created by Quyen Trinh on 4/24/19.
//  Copyright © 2019 Quyen Trinh. All rights reserved.
//

import UIKit

class LoadingButton: UIView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var buttonDidTap: (() -> Void)?
    
    @IBAction func buttonDidTap(_ sender: Any) {
        if let action = buttonDidTap {
            action()
        }
    }
    
    func startLoading() {
        button.isEnabled = false
        button.isHidden = true
        indicator.startAnimating()
    }
    
    func stopLoading() {
        button.isEnabled = true
        button.isHidden = false
        indicator.stopAnimating()
    }
}
