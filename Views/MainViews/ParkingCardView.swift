import SwiftUI

struct ParkingCardView: View {
    let parkingPlace: ParkingItem
    @State private var isCardVisible = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(parkingPlace.name)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(.green)
                
                Text(parkingPlace.address)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                HStack {
                    Image(systemName: "car.fill").foregroundColor(.green)
                    Text("\(parkingPlace.carLimit)")
                    Image(systemName: "eurosign.circle.fill").foregroundColor(.green)
                    Text("€\(String.init(format: "%0.2f", parkingPlace.fee))/h")
                }
            }
            Spacer()
            Image(parkingPlace.photoName)
                .resizable()
                .frame(width: 70, height: 70)
                .scaledToFit()
                .cornerRadius(15)
                .shadow(color: .white, radius: isCardVisible ? 10 : 0)
                .animation(.easeInOut(duration: 0.5))
        }
        .padding()
        .frame(width: 410, height: 125)
        .background(
            ZStack {
                Rectangle()
                    .foregroundColor(Color.black) // Set the parking card background color to black
                    .cornerRadius(20) // Adjusted corner radius
                    .scaleEffect(isCardVisible ? 1.0 : 0.8)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8))
            }
        )
        .cornerRadius(20) // Adjusted corner radius
        .opacity(isCardVisible ? 1.0 : 0.2)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isCardVisible = true
            }
        }
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
}

