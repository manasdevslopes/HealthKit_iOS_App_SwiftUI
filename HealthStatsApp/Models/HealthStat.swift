//
//  HealthStat.swift
//  HealthStatsApp
//
//  Created by MANAS VIJAYWARGIYA on 30/01/23.
//

import Foundation
import HealthKit

struct HealthStat: Identifiable {
  let id = UUID()
  let stat: HKQuantity?
  let date: Date
}
