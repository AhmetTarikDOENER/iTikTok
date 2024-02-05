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
    
    private let recordButton = RecordButton()
    
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
        view.addSubviews(cameraView, recordButton)
        setupCamera()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton)
        )
        recordButton.addTarget(self, action: #selector(didTapRecord), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraView.frame = view.bounds
        let size: CGFloat = 70
        recordButton.frame = CGRect(
            x: (view.width - size) / 2,
            y: view.height - view.safeAreaInsets.bottom - size - 5,
            width: size,
            height: size
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - Private
    @objc private func didTapRecord() {
        if captureOutput.isRecording {
            // Stop recording
            captureOutput.stopRecording()
        } else {
            // Start recording
            guard var url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else { return }
            url.appendingPathComponent("video.mov")
            
            try? FileManager.default.removeItem(at: url)
            
            captureOutput.startRecording(
                to: url,
                recordingDelegate: self
            )
        }
    }
    
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
            let alert = UIAlertController(
                title: "Woops",
                message: "Something went wrong when recording your video.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
        }
        print("Finished recording to url: \(outputFileURL.absoluteString)")
    }
}
