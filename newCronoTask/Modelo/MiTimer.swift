//
//  MiTimer.swift
//  newCronoTask
//
//  Created by Alberto Banet Masa on 14/11/2019.
//  Copyright © 2019 Alberto Banet Masa. All rights reserved.
//

import Foundation
import Combine

class MiTimer {
    let currentTimePublisher = Timer.TimerPublisher(interval: 0.01, runLoop: .main, mode: .default)
    let cancellable: AnyCancellable?
    
    init() {
        self.cancellable = currentTimePublisher.connect() as? AnyCancellable
    }
    
    deinit {
        self.cancellable?.cancel()
    }
   
}
