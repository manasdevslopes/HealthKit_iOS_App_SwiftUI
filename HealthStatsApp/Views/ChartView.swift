//
//  ChartView.swift
//  HealthStatsApp
//
//  Created by MANAS VIJAYWARGIYA on 30/01/23.
//

import SwiftUI
import Charts
import HealthKit

struct ChartView: View {
  let stats: [HealthStat]
  var activity: Activity
  @ObservedObject var viewModel: DetailViewModel
  
  var body: some View {
        Chart {
          RuleMark(y: .value("Goal", 500))
            .foregroundStyle(Color.mint)
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
            .annotation(alignment: .leading) {
              Text("Goal")
                .font(.caption)
                .foregroundColor(.secondary)
            }
          
          ForEach(stats) { stat in
            BarMark(x: .value("Days", viewModel.dateFormatter.string(from: stat.date)),
                    y: .value("Values", viewModel.value(from: stat.stat).value)
            )
            .foregroundStyle(Color.pink.gradient)
            .cornerRadius(2) // 0 for no conerRadius or some value
            .annotation(position: .top, alignment: .center, spacing: 10) {
              Text("\(viewModel.value(from: stat.stat).value)")
                .foregroundColor(.white)
                .rotationEffect(.degrees(-60))
            }
          }
        }
        .frame(height: 250)
        .chartYScale(domain: yAxisScale(activity))
        .chartYAxis {
          AxisMarks(position: .trailing) {mark in // position is leading, trailing
            AxisValueLabel()
            AxisGridLine()
          }
        }
        .chartPlotStyle { plotContent in
          plotContent
            .background(.mint.gradient.opacity(0.34))
            .border(.green, width: 1)
        }
  }
  
  func yAxisScale(_ activity: Activity) -> ClosedRange<Int> {
    switch activity.id {
      case "activeEnergyBurned":
        return 0...50
      case "appleExerciseTime":
        return 0...500
      case "appleStandTime":
        return 0...500
      case "distanceWalkingRunning":
        return 0...5
      case "stepCount":
        return 0...5000
      default: return 0...1000
    }
  }
}

struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    ChartView(stats: [HealthStat(stat: HKQuantity(unit: .count(), doubleValue: .pi), date: Date())], activity: Activity(id: "stepCount", name: "Step Count", image: "👣"), viewModel: DetailViewModel(activity: Activity(id: "steps", name: "Steps", image: "👣"), repository: HKRepository()))
  }
}
