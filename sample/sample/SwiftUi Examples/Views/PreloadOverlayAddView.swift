import SwiftUI

struct PreloadOverlayAddView: View {
    
    @State var showOverlay: Bool = false

    var body: some View {
        if showOverlay {
            AddOverlayScreen()
        } else {
            Button("Show ad") {
                showOverlay.toggle()
            }
        }
    }
}
