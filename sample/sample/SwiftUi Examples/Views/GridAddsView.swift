import SwiftUI

struct GridAddsView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0...20, id: \.self) { index in
                    // 300 x 250 size because this is only ad that is available to use
                    if index % 3 == 0 && index != 0 {
                        InlineAddView(masterTag: 987051)
                            .frame(width: 300, height: 250, alignment: .center)
                    } else {
                        Color.random
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                    }
                }
            }
        }
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
