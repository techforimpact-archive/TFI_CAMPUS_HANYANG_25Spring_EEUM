import SwiftUI

struct QRScannerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: QRScannerModel
    let onTokenScanned: (String) -> Void
    
    init(onTokenScanned: @escaping (String) -> Void = { _ in }) {
        self.onTokenScanned = onTokenScanned
        
        #if os(iOS) && !SKIP
        let service = QRScannerServiceiOS()
        #else
        let service = QRScannerServiceAndroid()
        #endif
        
        viewModel = QRScannerModel(qrService: service)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            SheetHeader()
            
            Spacer()
            
            if viewModel.hasPermission {
                scannerContentView
            } else {
                permissionView
            }
            
            Spacer()
        }
        .padding(16)
        .onAppear {
            viewModel.checkPermission()
        }
        .onChange(of: viewModel.tokenValue, {
            if let token = viewModel.tokenValue {
                onTokenScanned(token)
            }
        })
    }
}

private extension QRScannerView {
    var scannerContentView: some View {
        VStack(spacing: 16) {
            #if os(iOS) && !SKIP
            CameraPreviewView(viewModel: $viewModel)
                .frame(height: 400)
                .cornerRadius(8)
                .clipped()
            #else
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 400)
                .cornerRadius(8)
                .overlay {
                    Text("QR 코드를 카메라에 맞춰주세요")
                        .foregroundColor(.white)
                }
            #endif
            
            if viewModel.isScanning {
                VStack(spacing: 10) {
                    ProgressView()
                    
                    Text("토큰 스캔 중...")
                        .foregroundColor(.black)
                }
            }
            
            if let token = viewModel.tokenValue {
                VStack(spacing: 10) {
                    Text("토큰 스캔 완료")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    Text("토큰: \(token)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                }
            }
            
            HStack(spacing: 20) {
                if !viewModel.isScanning {
                    Button("스캔 시작") {
                        viewModel.startScanning()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                } else {
                    Button("스캔 중지") {
                        viewModel.stopScanning()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                if viewModel.tokenValue != nil {
                    Button("다시 스캔") {
                        viewModel.resetScan()
                        viewModel.startScanning()
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
    }
    
    var permissionView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 50))
                .foregroundColor(.white)
            
            Text("카메라 권한이 필요합니다")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("QR 코드에서 토큰을 스캔하기 위해\n카메라 접근 권한이 필요합니다")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Button("권한 허용하기") {
                viewModel.checkPermission()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
