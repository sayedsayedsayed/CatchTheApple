//
//  RulesView.swift
//  CatchTheApple
//
//  Created by Sayed Zulfikar on 25/05/23.
//

import SwiftUI

struct RulesView: View {
    let gameRules: [String] = [
        "Collect the apple into the basket to get points",
        "Points can be used to shoot a spear, indicated on the top left",
        "Tap and release anywhere on the screen to shoot a spear",
        "Points will be deducted if you shoot a spear or got hit by an apple",
        "You can't shoot if you have no point",
        "You will lose if your point drop below zero",
        "Shoot the monkey to win the game",
        "Monkey will recover health if you got hit by an apple",
        "Monkey's movement is completely random",
        "Monkey's health is indicated on the top right",
        "Monkey will speed up when its' health is low",
        "I will give you 3 points at the start because I'm a generous and humble person",
    ]
    
    var body: some View {
        NavigationView(){
            ZStack{
                VStack{
                    Image("theRules")
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(0.5)
                        .padding(.top, 10)
                        .padding(.bottom, 250)
                   
                    Spacer()
                    
                    NavigationLink{
                        HomeView().navigationBarHidden(true).navigationBarBackButtonHidden(true)
                    } label: {
                        Text("BACK")
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
                
                VStack (alignment: .leading){
                    ForEach(gameRules, id: \.self) { rule in
                        GameRuleView(rule: rule)
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 50)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(20)
                
            }
            .background(Image("rulesBg"))
                .ignoresSafeArea()
        }
    }
}

struct GameRuleView: View {
    let rule: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "circle.fill")
                .font(.caption)
                .foregroundColor(.black)
                .padding(.trailing, 2)
            
            
            Text(rule)
                .font(.subheadline)
                .padding(.vertical, 1)
        }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        RulesView()
    }
}
