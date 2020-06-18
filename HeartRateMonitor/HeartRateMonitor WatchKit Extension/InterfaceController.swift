//
//  InterfaceController.swift
//  HeartRateMonitor WatchKit Extension
//
//  Created by Final Year Project Account on 2020/3/12.
//  Copyright © 2020 Final Year Project Account. All rights reserved.
//  App Icon made by Freepik from www.flaticon.com
//

import WatchKit
import Foundation
import WatchConnectivity
import HealthKit


class InterfaceController: WKInterfaceController {
    // MARK: - Outlets
    @IBOutlet weak var heartRateLabel: WKInterfaceLabel!
    @IBOutlet weak var bpmLabel: WKInterfaceLabel!
    @IBOutlet weak var textLabel: WKInterfaceLabel!
    
    let session = WCSession.default
    
    // MARK: - Properties

    private let workoutManager = WorkoutManager()
    private let am = AuthorizationManager()
    
    // MARK: - Lifecycle

    override func willActivate() {
        super.willActivate()
        super.setTitle("Heart Monitor")
        bpmLabel.setHidden(true)
        textLabel.setHidden(false)
            
        workoutManager.delegate = self
        session.delegate = self
        session.activate()
    }
}

// MARK: - Workout Manager Delegate

extension InterfaceController: WorkoutManagerDelegate, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received data: \(message)")
        if (message["START"] as? String) != nil {
            bpmLabel.setHidden(false)
            textLabel.setHidden(true)
            workoutManager.start()
        }else if (message["STOP"] as? String) != nil{
            heartRateLabel.setText("--")
            textLabel.setHidden(false)
            bpmLabel.setHidden(true)
            workoutManager.stop()
        }else{
            /*
            let data: [String: Any] = ["permissions": rawValueForPermission as Any]
            session.sendMessage(data, replyHandler: nil, errorHandler: nil)*/
        }
    }

    func workoutManager(_ manager: WorkoutManager, didChangeStateTo newState: WorkoutState) {}

    func workoutManager(_ manager: WorkoutManager, didChangeHeartRateTo newHeartRate: HeartRate) {
        heartRateLabel.setText(String(format: "%0.0f", newHeartRate.bpm))
        
        let number = newHeartRate.bpm
        
        let data: [String: Any] = ["watch": number as Any]
        session.sendMessage(data, replyHandler: nil, errorHandler: nil)
    }
}
