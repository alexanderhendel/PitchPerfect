//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Hiro on 22/03/15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // hide stuff we dont need when the view is shown to the user
        stopRecordingButton.hidden = true
        recordingButton.enabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        // show recording label and the stop button
        recordingLabel.text = "recording..."
        stopRecordingButton.hidden = false
        recordingButton.enabled = false
        
        // record audio
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag) {
            // audio recording finished
            recAudio = RecordedAudio(soundTitle: recorder.url.lastPathComponent, fileURL: recorder.url)
            
            self.performSegueWithIdentifier("stopRecording", sender: recAudio)
        } else {
            // crap went wrong
            NSLog("recording failed")
            recordingButton.enabled = true
            stopRecordingButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            
            let playSoundVC: PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
            let data = sender as RecordedAudio
            
            playSoundVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecordingAudio(sender: UIButton) {
        // hide recording label and the stop button
        recordingLabel.text = "Tap to record."
        stopRecordingButton.hidden = true
        recordingButton.enabled = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

