import Foundation
import SwiftUI

class QRScannerModel: ObservableObject {
    @Published var tokenValue: String?
    @Published var isScanning: Bool = false
    @Published var hasPermission: Bool = false
    @Published var scanError: String?
    
    private var qrService: QRScannerService
    
    init(qrService: QRScannerService) {
        self.qrService = qrService
    }
    
    func checkPermission() {
        qrService.checkCameraPermission { hasPermission in
            DispatchQueue.main.async {
                self.hasPermission = hasPermission
            }
        }
    }
    
    func startScanning() {
        guard !isScanning else { return }
        
        isScanning = true
        scanError = nil
        tokenValue = nil
        
        qrService.startScanning { [weak self] token in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let token = token, !token.isEmpty {
                    self.tokenValue = token
                    self.isScanning = false
                    self.qrService.stopScanning()
                }
            }
        }
    }
    
    func stopScanning() {
        isScanning = false
        qrService.stopScanning()
    }
    
    func resetScan() {
        tokenValue = nil
        scanError = nil
    }
    
    func getScannedToken() -> String? {
        return tokenValue
    }
    
    #if os(iOS) && !SKIP
    func attachPreviewToView(_ view: UIView) {
        if let iosService = qrService as? QRScannerServiceiOS {
            iosService.attachPreviewToView(view)
        }
    }
    
    func updatePreviewFrame(_ frame: CGRect) {
        if let iosService = qrService as? QRScannerServiceiOS {
            iosService.updatePreviewFrame(frame)
        }
    }
    #endif
}
