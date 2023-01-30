//
//  Activity.swift
//  HealthStatsApp
//
//  Created by MANAS VIJAYWARGIYA on 30/01/23.
//

import Foundation

struct Activity: Identifiable, Hashable {
  var id: String
  var name: String
  var image: String
}

var allActivities: [Activity] = [
  Activity(id: "activeEnergyBurned", name: "Active Burned Calories", image: "⚡️"),
  Activity(id: "appleExerciseTime", name: "Exercise Time", image: "🏋🏻‍♂️"),
  Activity(id: "appleStandTime", name: "Stand Time", image: "🧍‍♂️"),
  Activity(id: "distanceWalkingRunning", name: "Distance Walking/Running", image: "🏃‍♂️"),
  Activity(id: "stepCount", name: "Step Count", image: "👣"),
]
