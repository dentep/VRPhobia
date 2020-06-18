//
//  HKUnit+BeatsPerMinute.swift
//  HeartRateMonitor WatchKit Extension
//
//  Created by Final Year Project Account on 2020/3/12.
//  Copyright © 2020 Final Year Project Account. All rights reserved.
//

import HealthKit

extension HKUnit {
    static func beatsPerMinute() -> HKUnit {
        return HKUnit.count().unitDivided(by: HKUnit.minute())
    }

}
