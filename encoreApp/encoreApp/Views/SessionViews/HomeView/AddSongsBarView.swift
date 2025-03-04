//
//  AddSongsBarView.swift
//  encoreApp
//
//  Created by Etienne Köhler on 30.06.20.
//  Copyright © 2020 NikolaiEtienne. All rights reserved.
//

import SwiftUI

struct AddSongsBarView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var musicController: MusicController = .shared
    @ObservedObject var userVM: UserVM
    @ObservedObject var searchResultListVM: SearchResultListVM
    @ObservedObject var songListVM: SongListVM
    @ObservedObject var playerStateVM: PlayerStateVM
    @Binding var isPlay: Bool
    @Binding var showAddSongSheet:Bool
    @Binding var currentlyInSession: Bool
    
    @ViewBuilder
    var body: some View {
        if self.userVM.isAdmin {
            HStack {
                playPauseButton
                Spacer().frame(width: 50)
                addButton
                Spacer().frame(width: 50)
                skipButton
            }.padding(10)
            .padding(.horizontal, 10)
            .background(self.colorScheme == .dark ? Color("darkgray") : Color(.white))
            .cornerRadius(25)
            .shadow(radius: 10)
        } else {
            addButton
        }
    }
    
    var addButton: some View {
        Button(action: { self.showAddSongSheet = true }) {
            ZStack {
                Circle().frame(width: 55, height: 55).foregroundColor(Color.white)
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(Color("purpleblue"))
            }
        }.sheet(isPresented: self.$showAddSongSheet) {
            SuggestSongView(searchResultListVM: self.searchResultListVM, userVM: self.userVM, songListVM: self.songListVM, playerStateVM: self.playerStateVM, currentlyInSession: self.$currentlyInSession)
        }
    }
    
    var playPauseButton: some View {
        Button(action: {
            if !(self.musicController.appRemote?.isConnected ?? false) {
                self.musicController.appRemote?.connect()
                if !(self.musicController.appRemote?.isConnected ?? false) {
                    self.musicController.appRemote?.authorizeAndPlayURI("")
                    self.musicController.appRemote?.connect()
                }
            }
            self.playerStateVM.isPlaying ? self.playerPause() : self.playerPlay()
        }) {
            ZStack {
                Image(systemName: self.playerStateVM.isPlaying ? "pause" : "play")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
            }
        }
    }
    
    var skipButton: some View {
        Button(action: { self.playerSkipNext() }) {
            Image(systemName: "forward.end")
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
        }
    }
    
    func playerPlay() {
        guard let url = URL(string: "https://api.encore-fm.com/users/"+"\(userVM.username)"+"/player/play") else {
            print("Invalid URL")
            return
            
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
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
                //self.isPlay = true
                //                do {
                //                    let decodedData = try JSONDecoder().decode(Song.self, from: data)
                //                    DispatchQueue.main.async {
                //                        print("Successfully post of player play")
                //
                //                    }
                //                } catch {
                //                    print("Error")
                //                }
            }
        }
        task.resume()
    }
    
    func playerPause() {
        guard let url = URL(string: "https://api.encore-fm.com/users/"+"\(userVM.username)"+"/player/pause") else {
            print("Invalid URL")
            return
            
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
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
                //self.isPlay = false
                //                do {
                //                    let decodedData = try JSONDecoder().decode(String.self, from: data)
                //                    DispatchQueue.main.async {
                //                        print("Successfully post of player pause")
                //
                //                    }
                //                } catch {
                //                    print("Error")
                //                }
            }
        }
        task.resume()
    }
    
    func playerSkipNext() {
        guard let url = URL(string: "https://api.encore-fm.com/users/"+"\(userVM.username)"+"/player/skip") else {
            print("Invalid URL")
            return
            
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
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
                self.isPlay = true
                //                do {
                //                    let decodedData = try JSONDecoder().decode(String.self, from: data)
                //                    DispatchQueue.main.async {
                //                        print("Successfully post of player pause")
                //
                //                    }
                //                } catch {
                //                    print("Error")
                //                }
            }
        }
        task.resume()
    }
}

struct AddSongsBarView_Previews: PreviewProvider {
    @State static var isPlay = false
    @State static var showAddSongSheet = false
    @State static var currentlyInSession = true
    
    static var previews: some View {
        AddSongsBarView(userVM: UserVM(),
                        searchResultListVM: SearchResultListVM(userVM: UserVM()), songListVM: SongListVM(userVM: UserVM()), playerStateVM: PlayerStateVM(userVM: UserVM()), isPlay: $isPlay, showAddSongSheet: $showAddSongSheet, currentlyInSession: $currentlyInSession)
    }
}
