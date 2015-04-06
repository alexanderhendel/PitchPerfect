//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Hiro on 30/03/15.
//  Copyright (c) 2015 alexhendel. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(soundTitle: String!, fileURL: NSURL!) {
    
        self.title = soundTitle
        self.filePathUrl = fileURL
    }
}
