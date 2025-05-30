#if os(iOS) && !SKIP
import Foundation
import AVFoundation
import UIKit

class QRScannerServiceiOS: NSObject, QRScannerServiceiOSProtocol, AVCaptureMetadataOutputObjectsDelegate {
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var completion: ((String?) -> Void)?
    private var isProcessing = false
    private weak var previewView: UIView?
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        default:
            completion(false)
        }
    }
    
    func startScanning(completion: @escaping (String?) -> Void) {
        self.completion = completion
        self.isProcessing = false
        
        if let existingSession = captureSession {
            if !existingSession.isRunning {
                DispatchQueue.global(qos: .background).async {
                    existingSession.startRunning()
                }
            }
            return
        }
        
        setupCaptureSession()
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        self.captureSession = captureSession
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            completion?(nil)
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            } else {
                completion?(nil)
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                completion?(nil)
                return
            }
            
            setupPreviewLayer(for: captureSession)
            
            DispatchQueue.global(qos: .background).async {
                captureSession.startRunning()
            }
        } catch {
            completion?(nil)
        }
    }
    
    private func setupPreviewLayer(for session: AVCaptureSession) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer = previewLayer
        
        if let previewView = previewView {
            DispatchQueue.main.async {
                previewLayer.frame = previewView.bounds
                previewView.layer.addSublayer(previewLayer)
            }
        }
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        isProcessing = false
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard !isProcessing else { return }
        
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue,
           metadataObject.type == .qr,
           !stringValue.isEmpty {
            
            isProcessing = true
            
            let tokenValue = stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            completion?(tokenValue)
        }
    }
    
    func attachPreviewToView(_ view: UIView) {
        self.previewView = view
        
        if let previewLayer = previewLayer {
            DispatchQueue.main.async {
                previewLayer.removeFromSuperlayer()
                previewLayer.frame = view.bounds
                view.layer.insertSublayer(previewLayer, at: 0)
            }
        }
    }
    
    func updatePreviewFrame(_ frame: CGRect) {
        DispatchQueue.main.async {
            self.previewLayer?.frame = frame
        }
    }
}
#endif
