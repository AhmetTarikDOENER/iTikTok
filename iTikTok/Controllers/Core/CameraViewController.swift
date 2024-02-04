//
//  CameraViewController.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 31.01.2024.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    // Capture Session
    var captureSession = AVCaptureSession()
    // Capture Device
    var videoCaptureDevice: AVCaptureDevice?
    // Capture Output
    var captureOutput = AVCaptureMovieFileOutput()
    // Capture Preview
    var capturePreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let cameraView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        
        return view
    }()
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(cameraView)
        setupCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - Private
    
    @objc private func didTapCloseButton() {
        captureSession.stopRunning()
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0
    }
    
    private func setupCamera() {
        // Add devices
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            let audioInput = try? AVCaptureDeviceInput(device: audioDevice)
            if let audioInput = audioInput {
                if captureSession.canAddInput(audioInput) {
                    captureSession.addInput(audioInput)
                }
            }
        }
        if let videoDevice = AVCaptureDevice.default(for: .video) {
            if let videoInput = try? AVCaptureDeviceInput(device: videoDevice) {
                if captureSession.canAddInput(videoInput) {
                    captureSession.addInput(videoInput)
                }
            }
        }
        // Update Session
        captureSession.sessionPreset = .hd1280x720
        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
        }
        // Configure preview
        capturePreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        capturePreviewLayer?.videoGravity = .resizeAspectFill
        capturePreviewLayer?.frame = view.bounds
        if let layer = capturePreviewLayer {
            cameraView.layer.addSublayer(layer)
        }
        // Enable camera start
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        guard error == nil else {
            return
        }
        print("Finished recording to url: \(outputFileURL.absoluteString)")
    }
}
