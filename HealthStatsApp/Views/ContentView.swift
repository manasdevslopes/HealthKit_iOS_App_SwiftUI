//
//  ContentView.swift
//  HealthStatsApp
//
//  Created by MANAS VIJAYWARGIYA on 30/01/23.
//

import SwiftUI

struct ContentView: View {
  private var repository = HKRepository()
  
  var items: [GridItem] {
    Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
  }
  
  var body: some View {
    NavigationStack {
      ScrollView(.vertical, showsIndicators: false) {
        LazyVGrid(columns: items, spacing: 10) {
          ForEach(allActivities) { activity in
            NavigationLink(value: activity) {
              CardView(activity)
            }
            .buttonStyle(PlainButtonStyle())
          }
        }
        .padding()
      }
      .navigationTitle("My Health Stats")
      .navigationDestination(for: Activity.self) { activity in
        DetailView(activity: activity, repository: repository)
      }
    }
    .onAppear {
      repository.requestAuthorization { status in
        print("Auth success: \(status)")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      ContentView()
    }
  }
}

extension ContentView {
  @ViewBuilder
  private func CardView(_ activity: Activity) -> some View {
    VStack {
      Text(activity.image)
        .frame(width: 50, height: 50)
        .background {
          RoundedRectangle(cornerRadius: 5).fill(.blue.opacity(0.2))
        }
      
      Text(activity.name)
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      RoundedRectangle(cornerRadius: 10).fill(.blue.opacity(0.2))
    }
  }
}
