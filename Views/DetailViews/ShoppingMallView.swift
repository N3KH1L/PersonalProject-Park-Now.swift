import SwiftUI

struct ParkingSpot: Identifiable {
    let id: UUID
    let name: String
    var isAvailable: Bool
}

struct ReservationConfirmation: Identifiable {
    let id = UUID()
    let message: String
}

struct ShoppingMallView: View {
    @State private var parkingSpots = [
        ParkingSpot(id: UUID(), name: "Spot 1", isAvailable: true),
        ParkingSpot(id: UUID(), name: "Spot 2", isAvailable: false),
        ParkingSpot(id: UUID(), name: "Spot 3", isAvailable: true),
        ParkingSpot(id: UUID(), name: "Spot 4", isAvailable: true),
        ParkingSpot(id: UUID(), name: "Spot 5", isAvailable: true),
        ParkingSpot(id: UUID(), name: "Spot 6", isAvailable: true),
        ParkingSpot(id: UUID(), name: "Spot 7", isAvailable: false),
        ParkingSpot(id: UUID(), name: "Spot 8", isAvailable: true),
        ParkingSpot(id: UUID(), name: "Spot 9", isAvailable: true),
        ParkingSpot(id: UUID(), name: "Spot 10", isAvailable: true)
    ]
    @State private var reservedSpot: ParkingSpot?
    @State private var confirmationMessage: ReservationConfirmation?

    var body: some View {
        NavigationView {
            ScrollView {
                HStack(spacing: 20) {
                    VStack(spacing: 20) {
                        ForEach(parkingSpots.prefix(5)) { spot in
                            ParkingSpotView(spot: spot, reserveParkingSpot: reserveParkingSpot)
                        }
                    }
                    
                    VStack(spacing: 20) {
                        ForEach(parkingSpots.suffix(5)) { spot in
                            ParkingSpotView(spot: spot, reserveParkingSpot: reserveParkingSpot)
                        }
                    }
                }
                .padding()
                .alert(item: $confirmationMessage) { confirmation in
                    Alert(title: Text(confirmation.message))
                }
            }
            .navigationTitle("Parking Spots")
        }
    }
    
    func reserveParkingSpot(_ spot: ParkingSpot) {
        // Check if no spot is currently reserved or the spot to reserve is the same as the currently reserved spot
        if reservedSpot == nil || reservedSpot?.id == spot.id {
            if let index = parkingSpots.firstIndex(where: { $0.id == spot.id }) {
                parkingSpots[index].isAvailable = false
                reservedSpot = parkingSpots[index]
                confirmationMessage = ReservationConfirmation(message: "Parking spot \(spot.name) reserved.")
                
                // Log the reservation
                print("Parking spot \(spot.name) reserved.")
            }
        } else {
            confirmationMessage = ReservationConfirmation(message: "You can only reserve one spot at a time.")
        }
    }
    
    func cancelReservation() {
        if let reservedSpot = reservedSpot, let index = parkingSpots.firstIndex(where: { $0.id == reservedSpot.id }) {
            parkingSpots[index].isAvailable = true
            self.reservedSpot = nil
            confirmationMessage = ReservationConfirmation(message: "Reservation canceled.")
        }
    }
}

struct ParkingSpotView: View {
    let spot: ParkingSpot
    let reserveParkingSpot: (ParkingSpot) -> Void // Closure to reserve parking spot
    
    var body: some View {
        VStack {
            Image(systemName: spot.isAvailable ? "car" : "car.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(spot.isAvailable ? .green : .red)
            
            Text(spot.name)
                .font(.title)
                .foregroundColor(.primary)
            
            if spot.isAvailable {
                Button(action: {
                    reserveParkingSpot(spot) // Call the closure to reserve parking spot
                }) {
                    Text("Reserve")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Button(action: {}) {
                    Text("Occupied")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct ShoppingMallView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingMallView()
    }
}

