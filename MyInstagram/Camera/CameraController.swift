//
//  CameraController.swift
//  MyInstagram
//
//  Created by Jinwoo Kim on 26/04/2019.
//  Copyright © 2019 jinuman. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        
        setupHeadsUpDisplay()
    }
    
    deinit {
        print("CameraController \(#function)")
    }
    
    fileprivate func setupHeadsUpDisplay() {
        [dismissButton, capturePhotoButton].forEach {
            view.addSubview($0)
        }
        
        let guide = view.safeAreaLayoutGuide
        
        dismissButton.anchor(top: guide.topAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: guide.trailingAnchor,
                             padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 12),
                             size: CGSize(width: 50, height: 50))
        
        capturePhotoButton.anchor(top: nil,
                                  leading: nil,
                                  bottom: guide.bottomAnchor,
                                  trailing: nil,
                                  padding: UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0),
                                  size: CGSize(width: 80, height: 80))
        capturePhotoButton.centerXInSuperview()
    }
    
    @objc fileprivate func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func handleCapturePhoto() {
        
    }
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        // 1. setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let err {
            print("Could not setup camera input:", err.localizedDescription)
        }
        
        // 2. setup outputs
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        
        // 3. setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}
