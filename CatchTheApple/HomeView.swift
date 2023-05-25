//
//  HomeView.swift
//  CatchTheApple
//
//  Created by Sayed Zulfikar on 25/05/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView(){
            ZStack{
                VStack{
                    
                    Image("logoCTA")
                        .resizable()
                        .scaledToFit()
                        .padding(.vertical, 50)
                    
                    Spacer()
                    
                    NavigationLink{
                        ContentView().navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    } label: {
                        Text("PLAY")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 100)
                    .background(
                        Capsule(style: .circular)
                            .fill(.red)
                    )
                    .padding(.bottom, 20)
                    
                    NavigationLink{
                        RulesView().navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    } label: {
                        Text("Rules")
                            .foregroundColor(.red)
                            .font(.title3)
                            .bold()
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 50)
                    .background(
                        Capsule(style: .circular)
                            .fill(.white)
                    )
                    
                    Spacer()
                    
                    
                }
            }
            .background(Image("homeBg"))
            .ignoresSafeArea()
            .onAppear{
                SoundManager.instance.PlayBGSound()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
