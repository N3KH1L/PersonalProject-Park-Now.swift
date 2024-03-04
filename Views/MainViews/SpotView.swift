import SwiftUI
import MapKit

struct SpotView: View {
    var onClose: () -> Void

    @State private var isGraphVisible = true
    @State private var isNewSpotShowing = false

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Placeholder image with pulsating animation
                Image(systemName: "")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(height: 200)
                    .scaleEffect(isGraphVisible ? 1.0 : 1.0)
                    .opacity(isGraphVisible ? 0.8 : 1.0)
                    .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true))
                    .onTapGesture {
                        withAnimation {
                            isGraphVisible.toggle()
                        }
                    }

                // Rental spot information
                VStack(alignment: .center, spacing: 8) {
                    Text("Your Parking Spot")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Price: €5 per hour") // Price (sample data)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .opacity(1.0)
                        .animation(Animation.easeInOut(duration: 0.5).delay(0.7))

                    // Usage graph (sample data)
                    UsageGraph(data: [30, 50, 80, 60, 90], isGraphVisible: $isGraphVisible)
                        .frame(height: 189)
                        .opacity(1.0)
                        .animation(Animation.easeInOut(duration: 0.5).delay(1.2))

                    // Average income per day (sample data)
                    Text("Average Income: \(calculateAverageIncome(data: [5, 10, 20, 6.75, 3.17]))")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                        .padding(.top, 25)

                    Spacer()
                }
                .padding()

                Spacer()

                Button(action: {
                    isNewSpotShowing.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(16)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                }


                .sheet(isPresented: $isNewSpotShowing) {
                    NewSpotFormView(isNewSpotShowing: $isNewSpotShowing)
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.blue]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
    }

    // Calculate average income and format
    private func calculateAverageIncome(data: [Double]) -> String {
        let hourlyRate = 5.0 // Sample hourly rate
        let totalIncome = data.reduce(0, +)
        let averageIncome = totalIncome * hourlyRate / Double(data.count)
        return String(format: "€%.2f", averageIncome)
    }
}
import SwiftUI
import MapKit

struct NewSpotFormView: View {
    @Binding var isNewSpotShowing: Bool
    @State private var spotName = ""
    @State private var spotAddress = ""
    @State private var spotPrice = ""
    @State private var spotAvailability = ""
    @State private var spotNotes = ""
    @State private var errorMessage = ""
    @State private var isLocationValid = true
    @State private var isLoading = false
    @State private var showingAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Parking Spot Details")) {
                    TextField("Spot Name", text: $spotName)
                        .textContentType(.name)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemBackground)))
                        .padding(.horizontal)

                    TextField("Address", text: $spotAddress)
                        .textContentType(.fullStreetAddress)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemBackground)))
                        .padding(.horizontal)

                    TextField("Price per Hour 1€ - 5€", text: $spotPrice)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemBackground)))
                        .padding(.horizontal)

                    TextField("Availability (e.g., weekdays, weekends)", text: $spotAvailability)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemBackground)))
                        .padding(.horizontal)

                    TextField("Notes", text: $spotNotes)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemBackground)))
                        .padding(.horizontal)

                    if !isLocationValid {
                        Text("Please enter a valid address.")
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    if isLoading {
                        ProgressView()
                            .padding(.top)
                    }
                }

                Section {
                    Button(action: saveSpot) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background((isFormValid() && isLocationValid) ? Color.blue : Color.gray)
                            .cornerRadius(8)
                    }
                    .disabled(!isFormValid() || !isLocationValid || isLoading)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top)
                    }
                }
            }
            .navigationBarTitle("Add New Spot", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                isNewSpotShowing.toggle()
            })
        }
        .padding()
    }

    // Function to validate form input
    // Function to validate form input
    private func isFormValid() -> Bool {
        let priceRange = 1...5
        if let price = Int(spotPrice), priceRange.contains(price) {
            return !spotName.isEmpty && !spotAddress.isEmpty && !spotAvailability.isEmpty
        }
        return false
    }


    // Function to save the spot
    private func saveSpot() {
        if isFormValid() {
            // Verify location
            verifyLocation()
        } else {
            errorMessage = "Please fill in all fields"
        }
    }

    // Function to verify the parking spot location
    // Function to verify the parking spot location
    private func verifyLocation() {
        isLoading = true
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(spotAddress) { placemarks, error in
            self.isLoading = false
            guard error == nil, let placemark = placemarks?.first else {
                print("Geocode failed with error: \(error?.localizedDescription ?? "")")
                isLocationValid = false
                errorMessage = "Failed to verify location. Please enter a valid address."
                return
            }
            if let location = placemark.location {
                print("Spot Name: \(spotName)")
                print("Price: \(spotPrice)")
                print("Availability: \(spotAvailability)")
                print("Location verified: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                isLocationValid = true
                // Save spot here
                isNewSpotShowing.toggle()
                // Optionally clear fields
                clearFields()
                // Show alert
                showingAlert = true
            } else {
                print("No location found")
                isLocationValid = false
                errorMessage = "Failed to verify location. Please enter a valid address."
            }
        }
    }



    // Function to clear form fields
    private func clearFields() {
        spotName = ""
        spotAddress = ""
        spotPrice = ""
        spotAvailability = ""
        spotNotes = ""
        errorMessage = ""
        isLocationValid = true
    }
}

struct NewSpotFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewSpotFormView(isNewSpotShowing: .constant(false))
    }
}


struct SpotView_Previews: PreviewProvider {
    static var previews: some View {
        SpotView(onClose: {})
    }
}

