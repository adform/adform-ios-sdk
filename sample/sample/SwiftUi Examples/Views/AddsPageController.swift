import SwiftUI

struct ColorView: View {
    let color: Color

    var body: some View {
        color
    }
}

struct AddsPageController: View {

    var body: some View {
        TabView {
            ColorView(color: .blue)
            InterstitialAddView(masterTag: 987063)
            ColorView(color: .red)
            InterstitialAddView(masterTag: 987063)
            ColorView(color: .brown)
            InterstitialAddView(masterTag: 987063)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
