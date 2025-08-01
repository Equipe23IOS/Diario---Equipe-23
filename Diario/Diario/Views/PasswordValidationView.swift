//
//  PasswordValidationView.swift
//  Diario
//
//  Created by iredefbmac_36 on 26/07/25.
//

import SwiftUI

struct PasswordValidationView: View {
    @State var attempts: Int = 1
    @State var password: String = ""
    @State var isSecure: Bool = false
    @State var showPopup: Bool = false
    @Binding var hasJustCreatedPassword: Bool
    @Binding var goToNotera: Bool
    @ObservedObject var passwordViewModel: PasswordViewModel
    
    func countdown() {
        var remainingTime = 10
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if(remainingTime == 0) {
                t.invalidate()
                attempts += 1
            }
            remainingTime -= 1
        }
    }
    
    var body: some View {
        ZStack {
            Color.canvas
                .ignoresSafeArea()
            
            if(attempts % 5 == 0) {
                EmptyView()
                
                Text("\(countdown())")
                    .hidden()
                
                Text("Try again in 30 seconds")
                    .font(.custom("Leorio", size: 24))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.caramel)
                
            } else {
                VStack {
                    if(hasJustCreatedPassword) {
                        Text("Insert the password you just created")
                            .font(.custom("Leorio", size: 24))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.caramel)
                    } else {
                        Text("Welcome back!")
                            .font(.custom("Leorio", size: 24))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.caramel)
                    }
                    
                    ZStack {
                        Group {
                            if(isSecure) {
                                TextField("Enter a password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                    .font(.custom("Leorio", size: 16))
                            } else {
                                SecureField("Enter a password", text: $password)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                    .font(.custom("Leorio", size: 16))
                            }
                        }
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                isSecure.toggle()
                            }, label: {
                                Image(systemName: isSecure ? "eye" : "eye.slash")
                                    .foregroundColor(.toast)
                            })
                        }
                        .padding()
                        .padding(.trailing, 10)
                    }
                    Button(action: {
                        if(passwordViewModel.validatePasswrd(password)) {
                            goToNotera.toggle()
                        } else {
                            attempts += 1
                            showPopup.toggle()
                        }
                    }, label: {
                        Capsule()
                            .fill(Color.toast)
                            .frame(width: 160, height: 40)
                            .overlay() {
                                Text("Log in")
                                    .font(.custom("Leorio", size: 20))
                                    .fontWeight(.medium)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .foregroundColor(.canvas)
                            }
                    })
                    .alert("Error", isPresented: $showPopup) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("The password is wrong")
                    }
                }
            }
        }
    }
}
