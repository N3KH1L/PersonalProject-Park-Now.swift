import SwiftUI

struct TopNavigationView: View {
    @State private var selectedCarIndex = 0

    @AppStorage("defaultPlateNumber") private var defaultPlateNumber: String = "ABC-123"

    private let carImages = ["car1", "car2", "car3", "car4", "car5", "car6", "car7", "car8"]

    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .trailing, spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    Image(carImages[selectedCarIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 95, height: 95)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .rotationEffect(.degrees(0))
                        .animation(.spring(response: 0.4, dampingFraction: 0.6))

                    Button(action: {
                        withAnimation {
                            selectedCarIndex = (selectedCarIndex + 1) % carImages.count
                        }
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.green)
                            .cornerRadius(20)
                            .shadow(color: .blue.opacity(0.5), radius: 5, x: 0, y: 3)
                            .rotationEffect(.degrees(-10))
                            .animation(.spring(response: 0.4, dampingFraction: 0.6))
                    }
                    .offset(x: 20, y: -20)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("My Car")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.gray)
                        .opacity(0.5)
                        .animation(.easeInOut(duration: 0.3))

                    Text(defaultPlateNumber)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        .opacity(1.0)
                        .animation(.easeInOut(duration: 0.3))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 10)
            )
            .offset(x: 120) // Adjust the offset to move the RoundedRectangle more to the left
        }
    }
}

struct TopNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TopNavigationView()
    }
}

