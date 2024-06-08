//
//  ResidentsViewController.swift
//  Person
//
//  Created by Gaurav Tiwari on 08/06/24.
//

import UIKit
import Combine

final class ResidentsViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView?
  
  private let viewModel = ResidencyViewModel()
  private var cancellables: Set<AnyCancellable> = []
  
  deinit {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupDataPipeline()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Task {
      await viewModel.fetchResidents()
      self.tableView?.reloadData()
    }
  }
  
  private func setupDataPipeline() {
    viewModel.$updates
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.handleResidentUpdates(for: $0)
      }
      .store(in: &cancellables)
  }
  
  private func handleResidentUpdates(for update: ResidentUpdateType?) {
    guard let update = update else { return }
    switch update {
      case .deleted(let indexPath):
        tableView?.beginUpdates()
        tableView?.deleteRows(at: [indexPath], with: .automatic)
        tableView?.endUpdates()
      case .updated(let indexPath):
        tableView?.reloadRows(at: [indexPath], with: .automatic)
    }
  }
}

//MARK: - Datasource
extension ResidentsViewController: UITableViewDataSource {  
  func tableView(
    _ tableView: UITableView, numberOfRowsInSection section: Int
  ) -> Int {
    viewModel.residents.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "ResidentTableViewCell", for: indexPath
    ) as! ResidentTableViewCell
    cell.resident = viewModel.residents[indexPath.row]
    cell.tappedOnCheckIn = {
      self.viewModel.checkInResident(with: $0)
    }
    return cell
  }
}
