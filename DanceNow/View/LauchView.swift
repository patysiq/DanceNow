//
//  LauchView.swift
//  DanceNow
//
//  Created by PATRICIA S SIQUEIRA on 20/06/21.
//

import SwiftUI

struct LauchView: View {
    @State private var isActive = false
    
    var body: some View {
        VStack {
            if isActive {
                HomeView()
            } else {
                ZStack {
                    Color("backColor")
                        .edgesIgnoringSafeArea(.all)
                    VStack(spacing: 10) {
                        Text("Dance Now")
                            .foregroundColor(Color("text"))
                            .font(.system(size: 60))
                            .bold()
                        LottieView(name: "dance", loopMode: .loop)
                            .frame(width: 250, height: 250)
                    }
                }
            }
        }
        .onAppear(perform: {
            self.gotoHomeView(time: 2.5)
        })
        
    }
    func gotoHomeView(time: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
            withAnimation {
                self.isActive = true
            }
        }
    }
}

struct LauchView_Previews: PreviewProvider {
    static var previews: some View {
        LauchView()
    }
}

