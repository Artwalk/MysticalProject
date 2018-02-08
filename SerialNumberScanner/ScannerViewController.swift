//
//  ScannerViewController.swift
//  SerialNumberScanner
//
//  Created by Art on 2/7/18.
//  Copyright © 2018 Art. All rights reserved.
//

import UIKit

import AVKit

class ScannerViewController: UIViewController {

    private var captureSession: AVCaptureSession!
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var maskView: UIView!
    @IBOutlet private weak var captureView: UIView!
    @IBOutlet private weak var line: UIView!

    @IBOutlet private weak var flashlightButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        hollowOutCameraView()
        startCapturing()

        if let captureDevice = AVCaptureDevice.default(for: .video) {
            flashlightButton.isHidden = !captureDevice.hasTorch
        }
    }

     let captureDevice = AVCaptureDevice.default(for: .video)

    @IBAction func flashlightButtonTouched(_ sender: UIButton) {
        turnFlashlight()
    }

    @IBAction private func returnButtonTouched(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ScannerViewController {
    private func turnFlashlight(_ on: AVCaptureDevice.TorchMode? = nil) {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }

        var torchOn: AVCaptureDevice.TorchMode!
        if let on = on {
            torchOn = on
        } else {
            torchOn = (captureDevice.torchMode == .on) ? AVCaptureDevice.TorchMode.off : .on
        }

        do {
            try captureDevice.lockForConfiguration()
            captureDevice.torchMode = torchOn
            captureDevice.unlockForConfiguration()
        } catch {
            print(error)
        }

    }

    private func startCapturing() {
        if let captureDevice = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)

                captureSession = AVCaptureSession()
                captureSession.addInput(input)

                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer.videoGravity = .resizeAspectFill
                videoPreviewLayer.frame = cameraView.layer.bounds
                cameraView.layer.addSublayer(videoPreviewLayer)
                cameraView.bringSubview(toFront: captureView)
            } catch {
                print(error)
            }
        }

        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: .main)
        captureSession?.addOutput(output)
        output.metadataObjectTypes = [.code128]

        captureSession.startRunning()

        let rect = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: captureView.frame)
        output.rectOfInterest = rect
    }

    private func hollowOutCameraView() {
        let mPath = UIBezierPath(rect: maskView.bounds)

        let rectangle = UIBezierPath(roundedRect: captureView.frame, cornerRadius: 9).reversing()

        mPath.append(rectangle)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = mPath.cgPath

        maskView.layer.mask = shapeLayer
    }

}

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.isEmpty {
            line.isHidden = true

            return
        }

        if let metadataObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject, var s = metadataObj.stringValue, 12...13 ~= s.count {
            captureSession.stopRunning()
            turnFlashlight(.off)

            if let codeObject = videoPreviewLayer.transformedMetadataObject(for: metadataObj) {
                line.isHidden = false
                line.frame = cameraView.convert(codeObject.bounds, to: captureView)
            }

            if s.count == 13 && (s.first == "S" || s.first == "s") {
                s.removeFirst()
            }

            SNModel.shared.newSN = s

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }

            print(metadataObj.type, s)
        }
    }
}
