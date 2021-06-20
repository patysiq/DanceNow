//
//  HomeView.swift
//  DanceNow
//
//  Created by PATRICIA S SIQUEIRA on 20/06/21.
//

import SwiftUI

struct HomeView: View {
   @State var page = "Home"
    
    init() {
        let appearance = UINavigationBarAppearance()
                // this overrides everything you have set up earlier.
                appearance.configureWithTransparentBackground()
                
                // this only applies to big titles
                appearance.largeTitleTextAttributes = [
                    .font : UIFont.systemFont(ofSize: 20),
                    NSAttributedString.Key.foregroundColor : UIColor.white
                ]
                // this only applies to small titles
                appearance.titleTextAttributes = [
                    .font : UIFont.systemFont(ofSize: 20),
                    NSAttributedString.Key.foregroundColor : UIColor(named: "text") ?? .systemPink
                ]
                
                //In the following two lines you make sure that you apply the style for good
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().standardAppearance = appearance
                
                // This property is not present on the UINavigationBarAppearance
                // object for some reason and you have to leave it til the end
                UINavigationBar.appearance().tintColor = .white

        }
   
    var body: some View {
        NavigationView {
            ZStack {
                Color("backgound").edgesIgnoringSafeArea(.all)
                VStack {
                    if page == "Home" {
                        Button("Dance now with me") {
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
                                        .foregroundColor(Color("text")).opacity(0.7))
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Dance Now", displayMode: .inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


