//
//  FinishView.swift
//  CatchTheApple
//
//  Created by Sayed Zulfikar on 25/05/23.
//

import SwiftUI
import AVFoundation

struct FinishView: View {
    var body: some View {
        NavigationView(){
            ZStack{
                VStack{
                    Image("congrats")
                        .resizable()
                        .scaledToFit()
                        .padding(.vertical, 50)
                        .onAppear {
                            SoundManager.instance.PlayCompleteSound()
                        }
                        .onDisappear {
                            SoundManager.instance.StopCompleteSound()
                            SoundManager.instance.PlayBGSound()
                        }
                    
                    Spacer()
                    
                    NavigationLink{
                        HomeView().navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    } label: {
                        Text("AGAIN")
                            .foregroundColor(.white)
                            .font(.title)
                            .bold()
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 100)
                    .background(
                        Capsule(style: .circular)
                            .fill(.red)
                    )
                    
                    Spacer()
                    
                    
                }
            }
            .background(Image("finishBg"))
            .ignoresSafeArea()
        }
    }
}

struct FinishView_Previews: PreviewProvider {
    static var previews: some View {
        FinishView()
    }
}
