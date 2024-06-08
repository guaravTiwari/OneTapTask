//
//  ServerReplica.swift
//  Person
//
//  Created by Gaurav Tiwari on 08/06/24.
//
//  This is a Mock that mimics a server, and DB using UserDefaults
//

import Foundation

extension String: Error {}

final class ServerReplica {
  func allParticipants() async throws -> Data {
    try await Task.sleep(until: .now + .seconds(2), clock: .continuous)
    guard let data = UserDefaults.standard.object(forKey: Constant.Data.peopleDataKey) as? Data else {
      throw "No Data Found"
    }
    return data
  }
  
  //  This method currently just fetches data for everyone
  //  and simply filters out for the person we need to find. Things dont work like this in actual scenarios.
  func person(with id: UUID) async throws -> Data {
    let data = try await allParticipants()
    let people = try JSONDecoder().decode([Person].self, from: data)
    guard let person = (people.filter { $0.id == id }).first else {
      throw "Noone found with id: \(id)"
    }
    
    return try JSONEncoder().encode(person)
  }
  
  func checkinMember(with id: UUID) async throws {
    let data = try await allParticipants()
    var participants = try JSONDecoder().decode([Participant].self, from: data)
    for index in 0..<participants.count {
      var participant = participants[index]
      if participant.id == id {
        participant.isPresent = true
        participants[index] = participant
        break
      }
    }
    updateTheDB(
      with: try JSONEncoder().encode(participants),
      becauseOfUpdatesForUserWithID: id
    )
  }
  
  private func updateTheDB(
    with updatedData: Data,
    becauseOfUpdatesForUserWithID id: UUID
  ) {
    UserDefaults.standard.set(updatedData, forKey: Constant.Data.peopleDataKey)
    if UserDefaults.standard.synchronize() {
      notifySuccessfulUpdateForUser(with: id)
    }
  }
  
  private func notifySuccessfulUpdateForUser(with id: UUID) {
    NotificationCenter.default.post(name: .userUpdated, object: id)
  }
}
