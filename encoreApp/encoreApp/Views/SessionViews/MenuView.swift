//
//  MenuView.swift
//  encoreApp
//
//  Created by Nikolai Madlener on 29.05.20.
//  Copyright © 2020 NikolaiEtienne. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var userVM: UserVM
    @ObservedObject var userListVM: UserListVM
    
    @Binding var currentlyInSession: Bool
    @State var showAlert = false
    @State var showSessionExpiredAlert = false
    @State var showShareSheet: Bool = false
    @State var showPopupQRCode: Bool = false
    
    init(userVM: UserVM, currentlyInSession: Binding<Bool>) {
        self.userVM = userVM
        self.userListVM = UserListVM(userVM: userVM, sessionID: nil)
        self._currentlyInSession = currentlyInSession
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                Image("Blob")
                    .scaledToFill()
                    .offset(y: -geometry.size.height/3.5)
                
                VStack(spacing: 0) {
                    
                    Spacer()
                        .frame(height: 40.0)
                    
                    HStack (alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Text("You're currently in")
                                .font(.title3.bold())
                                .foregroundColor(Color("Gray01"))
                            
                            Text("\(userListVM.members.first(where: { $0.is_admin })?.username ?? "Host")'s Session 🎧")
                                .font(.title.bold())
                                .foregroundColor(Color("Blue"))
                        }
                        
                        Spacer()
                        
                        leaveButton
                    }
                    .padding(.bottom, 35.0)
                    
                    QRCodeView(url: "encoreApp://\(self.userVM.sessionID)", size: 150)
                        .padding(10.0)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                        )
//                    .alert(isPresented: self.$showSessionExpiredAlert) {
//                        Alert(title: Text("Session expired"),
//                              message: Text("The Host has ended the Session."),
//                              dismissButton: .destructive(Text("Leave"), action: {
//                                self.currentlyInSession = false
//                              }))
//                    }
                    .padding(.bottom, -15)
                    
                    Button(action: { self.showShareSheet.toggle() }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                                .shadow(
                                    color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)),
                                    radius:25, x:0, y:4
                                )
                            
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(Color("Blue"))
                                .font(.title3)
                        
                        }
                    }
                    .offset(x: 85)
                    
                    Spacer()
                        .frame(height: 30)
                    
                    membersList
                    
                    Spacer()
                }
                .padding(.horizontal, 20.0)
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
            .sheet(isPresented: self.$showShareSheet) {
                ActivityViewController(activityItems: ["encoreApp://\(self.userVM.sessionID)"] as [Any], applicationActivities: nil)
            }.onAppear{
                self.getMembers(username: self.userVM.username)
            }
            
            if self.showPopupQRCode {
                popupQRView
            }
        }
    }
    
    var membersList: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack {
                    ForEach(self.userListVM.members.sorted(by: { $0.score > $1.score }), id: \.self) { member in
                        HStack {
                            Text("\((self.userListVM.members.sorted(by: { $0.score > $1.score }).firstIndex(of: member) ?? -1) + 1)")
                                .font(.system(size: 17, weight: .light))
                            if member.username == self.userVM.username {
                                Text("\(member.username)").font(.system(size: 17, weight: .semibold))
                            } else {
                                Text("\(member.username)").font(.system(size: 17, weight: .medium))
                            }
                            Spacer()
                            Text("\(member.score)").font(.system(size: 17, weight: .semibold))
                            Image(systemName: "heart")
                                .font(.system(size: 15, weight: .semibold))
                        }.foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
                        Divider()
                    }
                    Spacer().frame(height: 10)
                }.padding(.horizontal, 30)
            }
        }
    }
    
    var leaveButton: some View {
        Button {
            self.userVM.isAdmin ? (self.showAlert = true) : (self.leaveSession(username: self.userVM.username))
        } label: {
            Image(systemName: self.userVM.isAdmin ? "trash" : "rectangle.portrait.and.arrow.right")
                    .foregroundColor(Color.red)
                    .font(.title3)
        }
        .padding(.bottom)
        .alert(isPresented: self.$showAlert) {
            Alert(
                title: Text("Delete Session"),
                message: Text("By deleting the current session all members will be kicked."),
                primaryButton: .destructive(
                    Text("Delete"),
                    action: {
//                      TODO: Try to find a workaround to make this work again
//                      self.playerStateVM.playerPause()
                        self.deleteSession(username: self.userVM.username)
                    }),
                secondaryButton: .cancel(
                    Text("Cancel"),
                    action: {
                    self.showAlert = false
                    })
            )
        }
    }
    
    var popupQRView: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                PopupQRCodeView(userVM: self.userVM, showPopupQRCode: self.$showPopupQRCode)
            }.frame(width: geo.size.width,
                    height: geo.size.height,
                    alignment: .center)
        }.background(
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    self.showPopupQRCode.toggle()
                }
        )
    }
    
    func getMembers(username: String) {
        
        guard let url = URL(string: "https://api.encore-fm.com/users/"+"\(username)"+"/list") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        
        print("secret: " + self.userVM.secret)
        print("sessionID: " + self.userVM.sessionID)
        
        request.httpMethod = "GET"
        request.addValue(self.userVM.secret, forHTTPHeaderField: "Authorization")
        request.addValue(self.userVM.sessionID, forHTTPHeaderField: "Session")
        
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        //let postString = "userId=300&title=My urgent task&completed=false";
        // Set HTTP Request Body
        //request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                
                do {
                    let decodedData = try JSONDecoder().decode([UserListElement].self, from: data)
                    DispatchQueue.main.async {
                        
                    }
                } catch {
                    print("Error")
                    self.showSessionExpiredAlert = true
                    
                }
            }
            
        }
        task.resume()
    }
    
    func deleteSession(username: String) {
        
        guard let url = URL(string: "https://api.encore-fm.com/admin/"+"\(username)"+"/deleteSession") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        
        print("secret: " + userVM.secret)
        print("sessionID: " + userVM.sessionID)
        
        request.httpMethod = "DELETE"
        request.addValue(userVM.secret, forHTTPHeaderField: "Authorization")
        request.addValue(userVM.sessionID, forHTTPHeaderField: "Session")
        
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        //let postString = "userId=300&title=My urgent task&completed=false";
        // Set HTTP Request Body
        //request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
            self.currentlyInSession = false
        }
        task.resume()
    }
    
    func leaveSession(username: String) {
        
        guard let url = URL(string: "https://api.encore-fm.com/users/"+"\(username)"+"/leave") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        
        print("secret: " + userVM.secret)
        print("sessionID: " + userVM.sessionID)
        
        request.httpMethod = "DELETE"
        request.addValue(userVM.secret, forHTTPHeaderField: "Authorization")
        request.addValue(userVM.sessionID, forHTTPHeaderField: "Session")
        
        
        // HTTP Request Parameters which will be sent in HTTP Request Body
        //let postString = "userId=300&title=My urgent task&completed=false";
        // Set HTTP Request Body
        //request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string leave:\n \(dataString)")
            }
            self.currentlyInSession = false
        }
        task.resume()
    }
}

struct MenuView_Previews: PreviewProvider {
    static var userVM = UserVM()
    @State static var currentlyInSession = false
    
    static var previews: some View {
        MenuView(userVM: userVM, currentlyInSession: $currentlyInSession)
    }
}
