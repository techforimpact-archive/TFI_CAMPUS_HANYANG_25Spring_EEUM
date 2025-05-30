#if SKIP
import Foundation

class QRScannerServiceAndroid: QRScannerService {
    private var isScanning = false
    private var completion: ((String?) -> Void)?
    
    func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        // Skip이 이 코드를 Kotlin으로 변환하여 안드로이드 권한 체크 구현
        completion(true)
    }
    
    func startScanning(completion: @escaping (String?) -> Void) {
        guard !isScanning else { return }
        
        self.completion = completion
        self.isScanning = true
        
        // Skip이 이 코드를 Kotlin으로 변환하여 안드로이드 카메라 스캔 구현
    }
    
    func stopScanning() {
        isScanning = false
        completion = nil
        // Skip이 이 코드를 Kotlin으로 변환하여 안드로이드 카메라 중지 구현
    }
    
    // 안드로이드에서 QR 코드가 감지되었을 때 호출되는 함수
    func onQRCodeDetected(_ tokenValue: String) {
        guard isScanning, let completion = completion else { return }
        
        let trimmedToken = tokenValue.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedToken.isEmpty {
            self.isScanning = false
            completion(trimmedToken)
        }
    }
}
#endif
