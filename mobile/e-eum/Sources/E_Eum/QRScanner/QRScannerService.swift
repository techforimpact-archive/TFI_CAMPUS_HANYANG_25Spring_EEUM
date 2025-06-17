import UIKit

protocol QRScannerService {
    func checkCameraPermission(completion: @escaping (Bool) -> Void)
    func startScanning(completion: @escaping (String?) -> Void)
    func stopScanning()
}

#if os(iOS) && !SKIP
protocol QRScannerServiceiOSProtocol: QRScannerService {
    func attachPreviewToView(_ view: UIView)
    func updatePreviewFrame(_ frame: CGRect)
}
#endif
