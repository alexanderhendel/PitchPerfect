//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Hiro on 26/03/15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var receivedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // start with the audio player
        var error: NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: &error)
        audioPlayer.enableRate = true
        audioPlayer.volume = 1.0
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSnailSound(sender: UIButton) {
        
        // play sound slow / 50% speed
        self.playAudio(0.5, resetToStartofTrack: true)
    }

    @IBAction func playRabbitSound(sender: UIButton) {
        
        // play sound / 200% speed
        self.playAudio(2.0, resetToStartofTrack: true)
    }
    
    @IBAction func playChipmunkSound(sender: UIButton) {
        
        self.playAudio(1000)
    }
    
    @IBAction func playDarthSound(sender: UIButton) {
    
        self.playAudio(-1000)
    }
    
    @IBAction func stopPlayingSound(sender: UIButton) {
        
        // reset modifiers and stop playing
        audioPlayer.rate = 1.0
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
    }
    
    func playAudio(playSpeed: Float, resetToStartofTrack: Bool) {
    
        // ok, reset whats going on
        audioPlayer.stop()
        
        // play sound
        audioPlayer.rate = playSpeed
        
        if (resetToStartofTrack) {
        audioPlayer.currentTime = 0.0
        }
        
        audioPlayer.play()
    }
    
    func playAudio(withPitch: Float) {
        
        // ok, reset whats going on
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        var audioPitchEffect = AVAudioUnitTimePitch()
        
        audioPitchEffect.pitch = withPitch
        
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(audioPitchEffect)
        
        // attach the nodes via audioEngine
        audioEngine.connect(audioPlayerNode, to: audioPitchEffect, format: nil)
        audioEngine.connect(audioPitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }

}
