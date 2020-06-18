//
//  HKAuthorizationManger.swift
//  HeartRateMonitor WatchKit Extension
//
//  Created by Final Year Project Account on 2020/3/12.
//  Copyright © 2020 Final Year Project Account. All rights reserved.
//

import HealthKit
import WatchKit
import UIKit

class AuthorizationManager {
    static func requestAuthorization(completionHandler: ((_ success: Bool) -> Void)) {
        // Create health store.
        let healthStore = HKHealthStore()
        // Check if there is health data available.
        if (!HKHealthStore.isHealthDataAvailable()) {
            print("No health data is available.")
            completionHandler(false)
            return
        }

        // Create quantity type for heart rate.
        guard let heartRateQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            print("Unable to create quantity type for heart rate.")
            completionHandler(false)
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: [heartRateQuantityType]) { (_, _) in
            print("Authorising")
            
            //APPLE BUG
            print(healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .heartRate)!).rawValue)
        }
        
        
    }
}

