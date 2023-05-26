//
//  SoundManager.swift
//  CatchTheApple
//
//  Created by Sayed Zulfikar on 25/05/23.
//

import Foundation

import AVFoundation

class SoundManager{
    static let instance = SoundManager()
    
    var player : AVAudioPlayer?
    
    func PlayBGSound(){
        guard let url = Bundle.main.url(forResource: "roProntera", withExtension: ".mp3") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.numberOfLoops = -1
            player?.play()
        } catch let error{
            print("error playing sound. \(error.localizedDescription)")
        }
    }
    
    func StopBGSound(){
        guard let url = Bundle.main.url(forResource: "roProntera", withExtension: ".mp3") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.pause()
        } catch let error{
            print("error stopping sound. \(error.localizedDescription)")
        }
    }
    
    func PlayGameOverSound(){
        guard let url = Bundle.main.url(forResource: "game-over", withExtension: ".mp3") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.numberOfLoops = -1
            player?.play()
        } catch let error{
            print("error playing sound. \(error.localizedDescription)")
        }
    }
    
    func StopGameOverSound(){
        guard let url = Bundle.main.url(forResource: "game-over", withExtension: ".mp3") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.stop()
        } catch let error{
            print("error stopping sound. \(error.localizedDescription)")
        }
    }
    
    func PlayCompleteSound(){
        guard let url = Bundle.main.url(forResource: "GoodJobYeye", withExtension: "m4a") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.numberOfLoops = 0
            player?.play()
        } catch let error{
            print("error playing sound. \(error.localizedDescription)")
        }
    }
    
    func StopCompleteSound(){
        guard let url = Bundle.main.url(forResource: "GoodJobYeye", withExtension: "m4a") else {return}
        
        do{
            player = try AVAudioPlayer(contentsOf:url)
            player?.stop()
        } catch let error{
            print("error stopping sound. \(error.localizedDescription)")
        }
    }
}
