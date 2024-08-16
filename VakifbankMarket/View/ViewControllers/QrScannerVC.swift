//
//  QrScannerVC.swift
//  VakifbankMarket
//
//  Created by İbrahim Ay on 14.08.2024.
//

import UIKit
import AVFoundation

class QrScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var completion: ((String) -> Void)?
        
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupCamera()
        configureBackButton()
        
    }
    
    func configureBackButton() {
        view.addSubview(backButton)
        
        let originalImage = UIImage(systemName: "xmark")
        let resizedImage = originalImage?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        backButton.setImage(resizedImage, for: .normal)
        
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 30)
    }
    
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(stringValue)
        }
    }
        
    func foundCode(_ code: String) {
        let expectedQRCode = "https://scanned.page/66bc920b2b444"
        if code == expectedQRCode {
            captureSession.stopRunning()
            completion?(code)
            dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Geçersiz QR Kodu", message: "Bu QR kodu geçerli değil.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }

}
