//
//  LauchView.swift
//  DanceNow
//
//  Created by PATRICIA S SIQUEIRA on 20/06/21.
//

import SwiftUI

struct LauchView: View {
    
    var body: some View {
        ZStack{
            Color("background")
                .edgesIgnoringSafeArea(.all)
            LottieView(name: "dance", loopMode: .loop)
                .frame(width: 250, height: 250)
        }
    }
}

struct LauchView_Previews: PreviewProvider {
    static var previews: some View {
        LauchView()
    }
}
