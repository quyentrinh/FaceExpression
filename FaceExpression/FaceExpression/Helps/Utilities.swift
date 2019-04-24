//
//  Utilities.swift
//  FaceExpression
//
//  Created by Quyen Trinh on 4/24/19.
//  Copyright © 2019 Quyen Trinh. All rights reserved.
//

import UIKit

enum DetectOption: Int {
    case text = 0
    case face
    case barcode
}

class Utilities: NSObject {

}

extension UIViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
