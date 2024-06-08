//
//  ResidencyViewModel.swift
//  Person
//
//  Created by Gaurav Tiwari on 08/06/24.
//
//  I generally Write code using POP, but I need to finish this off as I need to go out so I am taking shortcuts.
//

import Foundation

enum ResidentUpdateType {
  case deleted(IndexPath), updated(IndexPath)
}

final class ResidencyViewModel: NSObject, ObservableObject {
  
  @Published var residents = [Person]()
  @Published var updates: ResidentUpdateType?
  
  private let readDataClient = DataReaderClient()
  private let writeDataClient = DataWriterClient()
  
  override init() {
    super.init()
    configureResidentsModificationListner()
  }
  
  @MainActor
  func fetchResidents() async {
    do {
      residents = try await readDataClient.fetchPeople()
    } catch {
      print(error)
    }
  }
  
  func checkInResident(with id: UUID) {
    writeDataClient.personJustCheckedIn(with: id)
  }
  
  private func configureResidentsModificationListner() {
    NotificationCenter.default.addObserver(
      forName: .userUpdated,
      object: nil, queue: .main
    ) { notification in
      guard let id = notification.object as? UUID else { return }
      Task {
        await self.fetchUpdatedResident(for: id)
      }
      print("User checked in with id: ", id)
    }
  }
  
  private func fetchUpdatedResident(for id: UUID) async {
    do {
      let resident = try await readDataClient.fetchPerson(with: id)
      updateResidents(with: resident, correspondingTo: id)
    } catch {
      print(error)
    }
  }
  
  private func updateResidents(with resident: Person?, correspondingTo id: UUID) {
    guard let index = residents.firstIndex(where: { $0.id==id }) else {
      return
    }
    
    let indexPath = IndexPath(row: index, section: 0)
    if let resident = resident {
      residents[index] = resident
      updates = .updated(indexPath)
    } else {
      residents.remove(at: index)
      updates = .deleted(indexPath)
    }
  }
}
