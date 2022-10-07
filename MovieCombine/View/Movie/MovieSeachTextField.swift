import SwiftUI


struct MovieSeachTextField: View {

    @Binding var text: String

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "magnifyingglass.circle")
            TextField("Search for a movie", text: $text)
        }
    }
}

