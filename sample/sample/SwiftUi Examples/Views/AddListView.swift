import SwiftUI

struct AddListView: View {
    var addFrequency = 5

    var body: some View {
        List(0..<20) { index in
            Text("Table list row \(index)")
            if index%addFrequency == 0 {
                InlineAddView(masterTag: 2172051)
                    .frame(width: 300, height: 250, alignment: .center)
            }
        }
    }
}
