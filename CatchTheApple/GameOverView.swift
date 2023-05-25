//
//  GameOverView.swift
//  CatchTheApple
//
//  Created by Sayed Zulfikar on 25/05/23.
//

import SwiftUI
import AVFoundation

struct GameOverView: View {
    
    var body: some View {
        NavigationView(){
            ZStack{
                VStack{
                    Image("gameOverIcon")
                        .resizable()
                        .scaledToFit()
                        .padding(.vertical, 50)
                        .onAppear {
                            SoundManager.instance.PlayGameOverSound()
                        }
                        .onDisappear {
                            SoundManager.instance.StopGameOverSound()
                            SoundManager.instance.PlayBGSound()
                        }
                    
                    Spacer()
                    
                    NavigationLink{
                        HomeView().navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    } label: {
                        Text("TRY AGAIN")
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
            .background(Image("gameOverBg"))
            .ignoresSafeArea()
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
