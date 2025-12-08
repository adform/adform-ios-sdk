import SwiftUI
import AdformAdvertising


struct AddOverlayScreen: UIViewControllerRepresentable {
    
    let adOverlay: AFAdOverlay = AFAdOverlay(masterTagID: 987063)
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        adOverlay.show(from: uiViewController)
    }
}
