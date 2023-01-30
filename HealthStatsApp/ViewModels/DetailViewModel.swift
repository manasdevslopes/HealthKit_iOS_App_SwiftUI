//
//  DetailViewModel.swift
//  HealthStatsApp
//
//  Created by MANAS VIJAYWARGIYA on 30/01/23.
//

import Foundation
import HealthKit

final class DetailViewModel: ObservableObject {
  var activity: Activity
  var repository: HKRepository
  
  @Published var stats = [HealthStat]()
  
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM"
    return formatter
  }()
  
  init(activity: Activity, repository: HKRepository){
    self.activity = activity
    self.repository = repository
    repository.requestHealthStat(by: activity.id) { healthStats in
      DispatchQueue.main.async {
        self.stats = healthStats
      }
    }
  }
  
  let measurementFormatter = MeasurementFormatter()
  
  func value(from stat: HKQuantity?) -> (value: Int, desc: String) {
    guard let stat = stat else { return (0, "") }
    
    measurementFormatter.unitStyle = .long
    
    if stat.is(compatibleWith: .kilocalorie()) {
      let value = stat.doubleValue(for: .kilocalorie())
      return (Int(value), stat.description)
    } else if stat.is(compatibleWith: .meter()) {
      let value = stat.doubleValue(for: .mile())
      let unit = Measurement(value: value, unit: UnitLength.miles)
      return (Int(value), measurementFormatter.string(from: unit))
    } else if stat.is(compatibleWith: .count()) {
      let value = stat.doubleValue(for: .count())
      return (Int(value), stat.description)
    } else if stat.is(compatibleWith: .minute()) {
      let value = stat.doubleValue(for: .minute())
      return (Int(value), stat.description)
    }
    
    return (0, "")
  }
}
