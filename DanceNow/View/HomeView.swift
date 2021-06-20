//
//  HomeView.swift
//  DanceNow
//
//  Created by PATRICIA S SIQUEIRA on 20/06/21.
//

import SwiftUI

struct HomeView: View {
   @State var page = "Home"
   
   var body: some View {
      VStack {
         if page == "Home" {
            Button("Switch to ARView") {
               self.page = "ARView"
            }
         } else if page == "ARView" {
            ZStack {
               NavigationIndicator()
               VStack {
                  Spacer()
                  Spacer()
                  Button("Home") {
                     self.page = "Home"
                  }.padding()
                  .background(RoundedRectangle(cornerRadius: 10)
                  .foregroundColor(Color.white).opacity(0.7))
               }
            }
         }
      }
   }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


