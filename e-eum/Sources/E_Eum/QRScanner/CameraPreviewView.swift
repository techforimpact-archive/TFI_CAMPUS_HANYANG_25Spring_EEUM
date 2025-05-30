#if os(iOS) && !SKIP
import SwiftUI
import UIKit
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var viewModel: QRScannerModel
    
    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.backgroundColor = UIColor.black
        
        DispatchQueue.main.async {
            self.viewModel.attachPreviewToView(view)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        DispatchQueue.main.async {
            self.viewModel.updatePreviewFrame(uiView.bounds)
        }
    }
}

class CameraPreviewUIView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.sublayers?.forEach { sublayer in
            if sublayer is AVCaptureVideoPreviewLayer {
                sublayer.frame = bounds
            }
        }
    }
}
#endif
