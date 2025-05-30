import SwiftUI

struct QRScannerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var qrCode: String
    
    @State private var viewModel: QRScannerModel
    @State private var showScanSuccessAlert: Bool = false
    @State private var showScanFailureAlert: Bool = false
    
    init (qrCode: Binding<String>) {
        self._qrCode = qrCode
        
        #if os(iOS) && !SKIP
        let service = QRScannerServiceiOS()
        #else
        let service = QRScannerServiceAndroid()
        #endif

        self.viewModel = QRScannerModel(qrService: service)
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
                qrCode = token
                showScanSuccessAlert = true
            } else {
                showScanFailureAlert = true
            }
        })
        .alert("QR 코드 스캔을 완료했습니다.", isPresented: $showScanSuccessAlert) {
            Button {
                dismiss()
            } label: {
                Text("확인")
            }
        }
        .alert("QR 코드 스캔을 실패했습니다.", isPresented: $showScanFailureAlert) {
            Button {
                viewModel.resetScan()
                viewModel.startScanning()
            } label: {
                Text("다시 시도하기")
            }
        }
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
                HStack(spacing: 8) {
                    ProgressView()
                    
                    Text("QR 스캔 중...")
                        .font(.title3)
                        .foregroundColor(.black)
                }
            } else {
                if viewModel.tokenValue != nil {
                    Text("QR 스캔 완료")
                        .font(.title3)
                        .foregroundStyle(Color.green)
                } else {
                    Text(" ")
                        .font(.title3)
                        .foregroundStyle(Color.clear)
                }
            }
            
            HStack(spacing: 16) {
                if !viewModel.isScanning {
                    BasicButton(title: "QR 스캔 시작", disabled: .constant(false)) {
                        viewModel.startScanning()
                    }
                } else {
                    BasicButton(title: "QR 스캔 중지", disabled: .constant(false)) {
                        viewModel.stopScanning()
                    }
                }
            }
        }
    }
    
    var permissionView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.fill")
                .font(.system(size: 50))
                .foregroundStyle(Color.white)
            
            Text("카메라 권한이 필요합니다")
                .font(.headline)
                .foregroundStyle(Color.white)
            
            Text("QR 코드에서 토큰을 스캔하기 위해\n카메라 접근 권한이 필요합니다")
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.gray)
            
            Button("권한 허용하기") {
                viewModel.checkPermission()
            }
            .padding()
            .background(Color.blue)
            .foregroundStyle(Color.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
