//
//  SongListCell.swift
//  encoreApp
//
//  Created by Nikolai Madlener on 26.05.20.
//  Copyright © 2020 NikolaiEtienne. All rights reserved.
//

import SwiftUI
import URLImage

struct SongListCell: View {
    @ObservedObject var userVM: UserVM
    @State var voteState: VoteState = VoteState.NEUTRAL
    @State var currentImage: Image = Image("albumPlaceholder")
    var song: Song
    var rank: Int
    
    var body: some View {
        HStack {
            //rankView.frame(width: 55)
            albumView
            songView
            Spacer()
            voteView
        }
        .padding(.horizontal, 40.0)
        .onAppear {
            if self.song.upvoters.contains(self.userVM.username) {
                self.voteState = .UPVOTE
            } else if self.song.downvoters.contains(self.userVM.username) {
                self.voteState = .DOWNVOTE
            } else {
                self.voteState = .NEUTRAL
            }
        }
    }
    
    private var rankView: some View {
        Text("\(rank)")
            .font(.footnote.bold())
            .padding(.horizontal, 10)
    }
    
    private var albumView: AnyView {
        if let url = URL(string: self.song.cover_url) {
            return AnyView(
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color("Gray06"))
                    
                    URLImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(5.0)
                            .frame(width: 45, height: 45)
                    }
                }
                .frame(width: 50, height: 50)
            )
        } else {
            return AnyView(
                RoundedRectangle(cornerRadius: 5.0)
                .fill(Color("Gray05"))
                .frame(width: 55, height: 55)
            )
        }
    }
    
    private var songView: some View {
        VStack(alignment: .leading) {
            
            Text(self.song.artists[0])
                .font(.caption2.bold())
                .foregroundColor(Color("Gray03"))
            
            Text(self.song.name)
                .font(.subheadline.bold())
                .lineLimit(1)
            
        }
        .padding(.horizontal, 10.0)
    }
    
    private var voteView: some View {
        HStack {
            Text("\(self.song.upvoters.count - self.song.downvoters.count)")
                .font(.footnote.bold())
                .foregroundColor(Color("Gray02"))
            
            Image(systemName: "heart")
                .font(.footnote.bold())
        }
    }
    
    private var upvoteButton: some View {
        Button(action: {
            switch self.voteState {
            case .NEUTRAL:
                self.upvote()
                self.voteState = VoteState.UPVOTE
            case .UPVOTE: break
            case .DOWNVOTE:
                self.upvote()
            }
        }) {
            Image(systemName: voteState == VoteState.UPVOTE ? "triangle.fill" : "triangle")
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(voteState == VoteState.UPVOTE ? voteState.color : Color.gray)
                .padding(.bottom, 3)
        }
    }
    
    private var downvoteButton: some View {
        Button(action: {
            switch self.voteState {
            case .NEUTRAL:
                self.downvote()
                self.voteState = VoteState.DOWNVOTE
            case .UPVOTE:
                self.downvote()
            case .DOWNVOTE: break
            }
        }) {
            Image(systemName: voteState == VoteState.DOWNVOTE ? "triangle.fill" : "triangle")
                .font(.system(size: 23, weight: .regular))
                .foregroundColor(voteState == VoteState.DOWNVOTE ? voteState.color : Color.gray)
                .rotationEffect(.degrees(-180))
                .padding(.top, 3)
        }
    }
    
    func upvote() {
        guard let url = URL(string: "https://api.encore-fm.com/users/"+"\(self.userVM.username)"+"/vote/"+"\(self.song.id)"+"/up") else {
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
                
                do {
                    let decodedData = try JSONDecoder().decode([Song].self, from: data)
                    DispatchQueue.main.async {
                        
                    }
                } catch {
                    print("Error Upvote")
                    //self.showSessionExpiredAlert = true
                    //self.currentlyInSession = false
                }
            }
        }
        task.resume()
    }
    
    func downvote() {
        guard let url = URL(string: "https://api.encore-fm.com/users/"+"\(self.userVM.username)"+"/vote/"+"\(self.song.id)"+"/down") else {
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
                
                do {
                    let decodedData = try JSONDecoder().decode([[Song]].self, from: data)
                    DispatchQueue.main.async {
                        
                    }
                } catch {
                    print("Error Downvote")
                    //self.showSessionExpiredAlert = true
                    //self.currentlyInSession = false
                }
            }
        }
        task.resume()
        
    }
}

struct SongListCell_Previews: PreviewProvider {
    static var previews: some View {
        SongListCell(userVM: UserVM(), song: Mockmodel.getSongs()[0], rank: 2)
    }
}

