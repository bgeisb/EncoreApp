//
//  AppContentView.swift
//  encoreApp
//
//  Created by Nikolai Madlener on 28.05.20.
//  Copyright © 2020 NikolaiEtienne. All rights reserved.
//

import SwiftUI
import Tabify

struct AppContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var userVM: UserVM
    @ObservedObject var userListVM: UserListVM
    @ObservedObject var songListVM: SongListVM
    @ObservedObject var playerStateVM: PlayerStateVM
    @ObservedObject var searchResultListVM: SearchResultListVM
    
    @State var currentlyInSession: Bool = false
    @State var showJoinSheet: Bool = false
    @State private var tabBarSelection: TabifyItems = .first
    
    var joinedViaURL: Bool
    var sessionID: String
    
    init(
        userVM: UserVM,
        joinedViaURL: Bool,
        sessionID: String
    ) {
        self.userVM = userVM
        self.userListVM = UserListVM(userVM: userVM, sessionID: nil)
        self.songListVM = SongListVM(userVM: userVM)
        self.playerStateVM = PlayerStateVM(userVM: userVM)
        self.searchResultListVM = SearchResultListVM(userVM: userVM)

        self.joinedViaURL = joinedViaURL
        self.sessionID = sessionID
    }

    
    var body: some View {
        return Group {
            ZStack {
                self.colorScheme == .dark ? Color("superdarkgray").edgesIgnoringSafeArea(.vertical) : Color.white.edgesIgnoringSafeArea(.vertical)
                
                if currentlyInSession {
                    Tabify(selectedItem: $tabBarSelection) {
                        HomeView(
                            userVM: userVM,
                            currentlyInSession: $currentlyInSession
                        )
                        .tabItem(for: TabifyItems.first)
                        
                        SuggestSongView(
                            searchResultListVM: self.searchResultListVM,
                            userVM: self.userVM,
                            songListVM: self.songListVM,
                            playerStateVM: self.playerStateVM,
                            currentlyInSession: self.$currentlyInSession
                        )
                        .tabItem(for: TabifyItems.second)
                        
                        MenuView(
                            userVM: self.userVM,
                            currentlyInSession: self.$currentlyInSession
                        )
                        .tabItem(for: TabifyItems.third)
                    }
                    .barStyle(style: CustomTabifyBarStyle())
                    .itemStyle(style: CustomTabifyItemStyle())
                }
                else {
                    LoginView(userVM: userVM, currentlyInSession: $currentlyInSession)
                        .sheet(isPresented: self.$showJoinSheet) {
                            JoinViaURLView(userVM: self.userVM, sessionID: self.sessionID, currentlyInSession: self.$currentlyInSession)
                    }
                }
            }
                
        }.onAppear{
            self.showJoinSheet = self.joinedViaURL
        }
    }
}

struct AppContentView_Previews: PreviewProvider {
    static var userVM = UserVM()

    static var previews: some View {
        AppContentView(userVM: userVM, joinedViaURL: false, sessionID: "")
    }
}
