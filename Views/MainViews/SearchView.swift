import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 22))
                .foregroundColor(.darkColor)
                .padding()

            TextField("Parking address...", text: $searchText)
                .foregroundColor(.black)
                .padding(.vertical, 5)

            Spacer()

            Image(systemName: "chevron.left")
                .foregroundColor(.darkColor)
                .padding()
        }
        .padding(.horizontal)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

