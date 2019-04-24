//
//  DetailViewController.swift
//  FaceExpression
//
//  Created by Quyen Trinh on 4/24/19.
//  Copyright © 2019 Quyen Trinh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var containView: CurvedView!
    
    var resultImage: UIImage?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    private var currentY: CGFloat = 0
    
    // Constant
    
    private let containHeight: CGFloat = 380.0          // 400 - extra height
    private let extraHeight: CGFloat = 20.0

    lazy private var contentViewTopMargin: CGFloat = {
        return view.bounds.height - containHeight
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        resultImageView.image = resultImage
        setupPanGestureRecognizer()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - SETUP
    
    private func setupPanGestureRecognizer() {
        let _panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
        _panGestureRecognizer.minimumNumberOfTouches = 1
        _panGestureRecognizer.maximumNumberOfTouches = 1
        containView.addGestureRecognizer(_panGestureRecognizer)
        panGestureRecognizer = _panGestureRecognizer
    }

    // MARK: SELECTOR
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        var translatePoint = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        
        let staticX = gestureRecognizer.view?.center.x
        
        if gestureRecognizer.state == .began {
            currentY = (gestureRecognizer.view?.center.y)!
        }
        
        translatePoint = CGPoint(x: staticX!, y: currentY + translatePoint.y)
        
        if translatePoint.y < (view.frame.size.height + contentViewTopMargin)*0.5 - extraHeight*0.5 {
            translatePoint.y = (view.frame.size.height + contentViewTopMargin)*0.5 - extraHeight*0.5
        }
        
        gestureRecognizer.view?.center = translatePoint
        if gestureRecognizer.state == .ended {
            
            let velocityY = 0.2*gestureRecognizer.velocity(in: view).y
            
            var finalY = translatePoint.y + velocityY
            
            let stopPoint1 = (view.frame.size.height + contentViewTopMargin)*0.5 + extraHeight*0.5
            let stopPoint2 = view.frame.size.height + containHeight*0.25
            
            if finalY > stopPoint2 {
                finalY = stopPoint2
            } else {
                finalY = stopPoint1
            }
            
            let animationDuration = abs(velocityY*0.0002) + 0.3
            
            UIView.beginAnimations("", context: nil)
            UIView.setAnimationDuration(TimeInterval(animationDuration))
            UIView.setAnimationCurve(.easeOut)
            gestureRecognizer.view?.center = CGPoint(x: staticX!, y: finalY)
            UIView.commitAnimations()
            
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultCell
        return cell
    }
    
    
}
