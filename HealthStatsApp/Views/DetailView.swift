//
//  DetailView.swift
//  HealthStatsApp
//
//  Created by MANAS VIJAYWARGIYA on 30/01/23.
//

import SwiftUI

struct DetailView: View {
  var activity: Activity
  var repository: HKRepository
  @ObservedObject var viewModel: DetailViewModel
  
  init(activity: Activity, repository: HKRepository) {
    self.activity = activity
    self.repository = repository
    
    viewModel = DetailViewModel(activity: activity, repository: repository)
  }
  
    var body: some View {
      VStack(alignment: .leading) {
        ChartView(stats: viewModel.stats, activity: activity, viewModel: viewModel)
          .padding(.bottom, 20)
          .padding(.top, 20)
          .padding(.horizontal, 16)
        
        List {
          ForEach(viewModel.stats) { stat in
            VStack(alignment: .leading) {
              Text(viewModel.value(from: stat.stat).desc)
              Text(stat.date, style: .date).opacity(0.5)
            }
          }
        }
      }
      .navigationTitle("\(activity.name) \(activity.image)")
      .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
      DetailView(
        activity: Activity(id: "steps", name: "Steps", image: "👣"),
        repository: HKRepository())
    }
}
