import SwiftUI

struct ParkingInfoView: View {
    
    let parkingItem: ParkingItem
    @Binding var showSelectHourView: Bool
    @Binding var selectedHour: CGFloat
    @Binding var showShoppingMallView: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text(parkingItem.name)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
            
            Text(parkingItem.address)
                .font(.system(size: 16))
                .foregroundColor(.white)
            
            HStack {
                Image(systemName: "car.fill").foregroundColor(.gray)
                
                Text("\(parkingItem.carLimit)")
                    .foregroundColor(.white)
                    .padding(.trailing, 16)
                
                Image(systemName: "eurosign.circle.fill").foregroundColor(.gray)
                
                Text("€\(String.init(format: "%0.2f", parkingItem.fee))/h").foregroundColor(.gray)
            }
            .font(.system(size: 16))
            
            HStack(spacing: 10) {
                NavigationLink(destination: ShoppingMallView(), isActive: $showShoppingMallView) {
                    InfoItemView(imageName: "place", value: parkingItem.place, title: "Parking Place")
                }
                .onTapGesture {
                    withAnimation {
                        showShoppingMallView = true
                    }
                }

                InfoItemView(imageName: "cost", value: getHour(), title: "Time")
                    .onTapGesture {
                        withAnimation { showSelectHourView = true }
                    }
            }
        }
        .padding() // Add padding as needed
    }
    
    func getHour() -> String {
        let hourSeparated = modf(selectedHour/2)
        let hourData = String(format: "%0.0f", hourSeparated.0)
        let minuteData = hourSeparated.1 == 0.0 ? "0" : "30"
        return "\(hourData) h \(minuteData) m"
    }
}

struct ParkingInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

