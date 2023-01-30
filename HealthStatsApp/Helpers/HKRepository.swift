//
//  HKRepository.swift
//  HealthStatsApp
//
//  Created by MANAS VIJAYWARGIYA on 30/01/23.
//

import Foundation
import HealthKit

final class HKRepository {
  var store: HKHealthStore? /// - Health care related informantion is stored
  
  let allTypes = Set([
    HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
    HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
    HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
    HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
    HKObjectType.quantityType(forIdentifier: .stepCount)!,
  ])
  
  var query: HKStatisticsCollectionQuery?
  
  init() {
    store = HKHealthStore()
  }
  
  func requestAuthorization(completion: @escaping (Bool) -> ()) {
    guard let store = store else { return }
    store.requestAuthorization(toShare: [], read: allTypes) { success, error in
      completion(success)
    }
  }
}

extension HKRepository {
  func requestHealthStat(by category: String, completion: @escaping ([HealthStat]) -> ()) {
    guard let store = store,
          let type = HKObjectType.quantityType(forIdentifier: typeByCategory(category: category)) else { return }
    let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    let endDate = Date()
    let anchorDate = Date.firstDayOfWeek()
    let dailyComponent = DateComponents(day: 1)
    
    var healthStats = [HealthStat]()
    
    let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    
    query = HKStatisticsCollectionQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: anchorDate, intervalComponents: dailyComponent)
    
    query?.initialResultsHandler = { query, statistics, error in
      statistics?.enumerateStatistics(from: startDate, to: endDate, with: { stats, _ in
        let stat = HealthStat(stat: stats.sumQuantity(), date: stats.startDate)
        healthStats.append(stat)
      })
      completion(healthStats)
    }
    guard let query = query else { return }
    store.execute(query)
  }
  
  private func typeByCategory(category: String) -> HKQuantityTypeIdentifier {
    switch category {
      case "activeEnergyBurned":
        return .activeEnergyBurned
      case "appleExerciseTime":
        return .appleExerciseTime
      case "appleStandTime":
        return .appleStandTime
      case "distanceWalkingRunning":
        return .distanceWalkingRunning
      case "stepCount":
        return .stepCount
      default:
        return .stepCount
    }
  }
}
