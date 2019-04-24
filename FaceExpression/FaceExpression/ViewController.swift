//
//  ViewController.swift
//  FaceExpression
//
//  Created by Quyen Trinh on 4/24/19.
//  Copyright © 2019 Quyen Trinh. All rights reserved.
//

import UIKit
import AWSRekognition


class ViewController: UIViewController {

    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var startButton: LoadingButton!
    
    private var detectOption: DetectOption = .face
    private var inputImage: UIImage!
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    var rekognitionObject:AWSRekognition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        rekognitionObject = AWSRekognition.default()
//        let celebImageAWS = AWSRekognitionImage()
////        celebImageAWS?.bytes =
//        let faceRequest = AWSRekognitionDetectFacesRequest()
//        faceRequest?.attributes = ["ALL"]
//        faceRequest?.image = AWSRekognitionImage()
//        rekognitionObject?.detectFaces(faceRequest!, completionHandler: { respond, error in
//
//        })
    }
    
    private func setup() {
        startButton.buttonDidTap = { [weak self] in
            guard let self = self else {
                fatalError()
            }

            switch self.detectOption {
            case .text:
                self.analysisText()
            case .face:
                self.analysisFace()
            case .barcode:
                self.analysisBarcode()
            }
        }
    }
    
    // MARK: - SELECTOR

    @IBAction func optionSegmentDidChange(_ sender: Any) {
        guard let segment = sender as? UISegmentedControl else {
            return
        }
        detectOption = DetectOption(rawValue: segment.selectedSegmentIndex) ?? .text
    }
    @IBAction func addButtonDidTap(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Open Photo Library", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.openPhotoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - ACTION
    
    private func analysisText() {
    }
    
    private func analysisFace() {
    }
    
    private func analysisBarcode() {
    }
    
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: {
                self.imagePicker.navigationBar.tintColor = .black
            })
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }

        inputImage = image
        inputImageView.image = image
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
}
