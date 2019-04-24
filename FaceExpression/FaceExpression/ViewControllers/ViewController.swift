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
    
    
    
    var rekognition: AWSRekognition = AWSRekognition.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        configureAWSRekognition()
        
        startButton.buttonDidTap = { [weak self] in
            guard let self = self else {
                fatalError()
            }
            
//            if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
//                detailVC.resultImage = self.inputImage
//                self.navigationController?.pushViewController(detailVC, animated: true)
//            }

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
    
    private func configureAWSRekognition() {
        //
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
        guard let inputImage = inputImage,
              let data = inputImage.jpegData(compressionQuality: 0.4),
              let awsImage = AWSRekognitionImage(),
              let faceRequest = AWSRekognitionDetectFacesRequest() else {
                  return
              }
        
        DispatchQueue.main.async {
            self.startButton.startLoading()
        }
        
        awsImage.bytes = data
        
        faceRequest.attributes = ["ALL"]
        faceRequest.image = awsImage
        rekognition.detectFaces(faceRequest, completionHandler: { [weak self] respond, error in
            guard let self = self else {
                fatalError()
            }
            DispatchQueue.main.async {
                self.startButton.stopLoading()
            }
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlert(message: error!.localizedDescription)
                }
            }
            guard let result = respond else {
                DispatchQueue.main.async {
                    self.showAlert(message: "NO RESULT")
                }
                return
            }
            print(result)
        })
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
    
    // MARK: - DATA HANDLE
    
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
