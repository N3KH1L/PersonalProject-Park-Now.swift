import SwiftUI
import LocalAuthentication // Import LocalAuthentication framework for Face ID

struct PaymentView: View {
    @Binding var selectedHour: CGFloat
    let perHourFee: CGFloat
    @State private var isLoading = false
    @State private var showSuccess = false
    @State private var isParkingClockVisible = false
    
    // State variable to track Face ID authentication status
    @State private var isFaceIDAuthenticated = false
    
    // State variable to track the amount paid
    @State private var amountPaid: Double = 0.0

    var body: some View {
        VStack {
            Text("€\(String(format: "%.2f", selectedHour/2 * perHourFee))")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.green)

            Spacer()

            if isLoading {
                ProgressView {
                    Text("Processing...")
                        .foregroundColor(.green) // Set text color to green
                }
                .progressViewStyle(CircularProgressViewStyle(tint: .green)) // Set progress tint color
                .padding()
            } else {
                // Show Face ID authentication if not authenticated
                if !isFaceIDAuthenticated {
                    FaceIDView(isFaceIDAuthenticated: $isFaceIDAuthenticated)
                        .padding()
                } else {
                    SwipeToPayView(action: {
                        isLoading = true
                        // Simulate payment processing
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...3)) {
                            isLoading = false
                            showSuccess = true
                            amountPaid = Double(selectedHour/2 * perHourFee)
                            // Log the amount paid
                            print("Amount Paid: €\(String(format: "%.2f", amountPaid))")
                        }
                    })
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showSuccess) {
            SuccessView(startParkingAction: {
                isParkingClockVisible = true
            })
            .fullScreenCover(isPresented: $isParkingClockVisible) {
                ParkingClockView(stopParkingAction: {
                    withAnimation {
                        isParkingClockVisible = false
                        showSuccess = false  // Close the PaymentView
                    }
                }, selectedHour: selectedHour)
            }
        }
        .padding()
    }
}


// View for Face ID authentication
// View for Face ID authentication
struct FaceIDView: View {
    @Binding var isFaceIDAuthenticated: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
                // Perform Face ID authentication
                authenticateWithFaceID()
            }) {
                Text("Authenticate with Face ID")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 0)
                    )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
            }
        }
    }
    
    // Function to authenticate with Face ID
    private func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        // Check if Face ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Perform Face ID authentication
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { success, authenticationError in
                // Check if authentication was successful
                if success {
                    // Authentication successful
                    DispatchQueue.main.async {
                        isFaceIDAuthenticated = true
                    }
                } else {
                    // Authentication failed
                    print("Face ID authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                }
            }
        } else {
            // Face ID not available
            print("Face ID not available on this device")
        }
    }
}


struct AnimatedCarClockView: View {
    var selectedHour: CGFloat
    @State private var remainingTime: Int
    @State private var pulsate = false

    init(selectedHour: CGFloat) {
        self.selectedHour = selectedHour
        _remainingTime = State(initialValue: Int(selectedHour * 60 * 60 / 2))
    }

    var body: some View {
        VStack {
            Spacer()

            Image("car1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .overlay(
                    Circle()
                        .stroke(Color.green, lineWidth: 25)
                        .scaleEffect(pulsate ? 1.5 : 1.0)
                        .opacity(pulsate ? 0.2 : 0.0) // Optional: Adjust opacity for a fading effect
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
                        .onAppear {
                            self.pulsate.toggle() // Initial trigger to start the pulsating animation
                        }
                )

            Text("\(formattedTime(seconds: remainingTime))")
                .font(.title)
                .bold()
                .foregroundColor(.green)
                .padding()

            Spacer()
        }
        .onAppear {
            // Timer to update the countdown
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                }
            }
        }
    }

    private func formattedTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
    }
}


struct SwipeToPayView: View {
    var action: () -> Void
    @State private var offset: CGSize = .zero
    @State private var hasPaid = false
    
    // State variable to track Face ID authentication status
    @State private var isFaceIDAuthenticated = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(hasPaid ? Color.green : Color.green)
                .frame(height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white, lineWidth: 0) // Adjusted stroke width
                )
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                .opacity(hasPaid ? 0.6 : 1.0)

            HStack {
                if !hasPaid {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.black)
                        .font(.system(size: 30))
                        .offset(x: hasPaid ? -25 : 0) // Hide arrow after payment
                        .animation(.easeInOut) // Apply animation
                }

                Text("Swipe to Pay")
                    .font(.system(size: 20, weight: .semibold)) // Adjusted font size
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
            }
            .offset(x: offset.width, y: -15)
            .animation(.spring())
            .gesture(DragGesture().onChanged { value in
                if !hasPaid {
                    offset = value.translation
                }
            }.onEnded { value in
                if offset.width > 100 {
                    // Perform Face ID authentication when swiping to pay
                    authenticateWithFaceID()
                }
                offset = .zero
            })
        }
    }
    
    // Function to authenticate with Face ID
    private func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        
        // Check if Face ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Perform Face ID authentication
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate with Face ID") { success, authenticationError in
                // Check if authentication was successful
                if success {
                    // Authentication successful
                    DispatchQueue.main.async {
                        isFaceIDAuthenticated = true
                        // Call the action when authentication succeeds
                        if !hasPaid {
                            action()
                            hasPaid = true
                        }
                    }
                } else {
                    // Authentication failed
                    print("Face ID authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                }
            }
        } else {
            // Face ID not available
            print("Face ID not available on this device")
        }
    }
}

struct SuccessView: View {
    var startParkingAction: () -> Void

    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(.green)

            Text("Payment Successful!")
                .font(.largeTitle)
                .foregroundColor(.green)
                .padding()

            Spacer()

            Button(action: {
                // Start Parking action
                startParkingAction()
            }) {
                Text("Start Parking")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 0)
                    )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
            }
        }
    }
}

struct ParkingClockView: View {
    var stopParkingAction: () -> Void
    var selectedHour: CGFloat

    var body: some View {
        VStack {
            AnimatedCarClockView(selectedHour: selectedHour)

            Spacer()

            Button(action: {
                // Stop Parking action
                withAnimation {
                    stopParkingAction()
                }
            }) {
                Text("Stop Parking")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 0)
                    )
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
            }
        }
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(selectedHour: .constant(1.0), perHourFee: 10.0)
    }
}

