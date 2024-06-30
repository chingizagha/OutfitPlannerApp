//
//  OutfitSelectVC.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 17.05.24.
//

import UIKit

class OutfitSelectVC: UIViewController {
    
    private let viewModel = OutfitSelectViewModel()
    
    var selectedRows = [String:IndexPath]()
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OutfitSelectCell.self, forCellReuseIdentifier: OutfitSelectCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

       title = "Select Clothes"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(didTapNextButton))
        
        layoutUI()
        getClothes()
    }
    
    private func getClothes() {
        viewModel.fetchData()
        for dress in viewModel.dressArray {
            switch dress.type{
            case .jacket:
                viewModel.jacketArray.append(dress)
            case .shirt:
                viewModel.tshirtArray.append(dress)
            case .pants:
                viewModel.jeansArray.append(dress)
            case .shoes:
                viewModel.shoesArray.append(dress)
            case .extras:
                viewModel.otherArray.append(dress)
            }
        }
    }
    
    @objc
    private func didTapNextButton() {
        
        if selectedRows.count == 0 {
            let alert = AlertViewHelper.showAlert(message: "Select at least one dress...")
            present(alert, animated: true)
        }
    
        for (section, indexPath) in selectedRows {
            switch section{
            case "0":
                viewModel.selectedDressArray.append(viewModel.jacketArray[indexPath.row])
            case "1":
                viewModel.selectedDressArray.append(viewModel.tshirtArray[indexPath.row])
            case "2":
                viewModel.selectedDressArray.append(viewModel.jeansArray[indexPath.row])
            case "3":
                viewModel.selectedDressArray.append(viewModel.shoesArray[indexPath.row])
            case "4":
                viewModel.selectedDressArray.append(viewModel.otherArray[indexPath.row])
            default:
                fatalError()
            }
        }
        
        print(viewModel.selectedDressArray)
        let vm = OutfitCreateViewModel(selectedDressArray: viewModel.selectedDressArray)
        let vc = OutfitCreateVC(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func layoutUI(){
        
        view.addSubviews(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    

}

extension OutfitSelectVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        ClothesType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        ClothesType.allCases[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        if section == 0 {
            count = viewModel.jacketArray.count
        }
        else if section == 1 {
            count = viewModel.tshirtArray.count
        }
        else if section == 2 {
            count = viewModel.jeansArray.count
        }
        else if section == 3 {
            count = viewModel.shoesArray.count
        }
        else if section == 4 {
            count = viewModel.otherArray.count
        }
        return count!

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OutfitSelectCell.identifier, for: indexPath) as? OutfitSelectCell else { fatalError() }
        
        switch (indexPath.section) {
        case 0:
            cell.configure(dress: viewModel.jacketArray[indexPath.row])
        case 1:
            cell.configure(dress: viewModel.tshirtArray[indexPath.row])
        case 2:
            cell.configure(dress: viewModel.jeansArray[indexPath.row])
        case 3:
            cell.configure(dress: viewModel.shoesArray[indexPath.row])
        case 4:
            cell.configure(dress: viewModel.otherArray[indexPath.row])
        default:
            fatalError()
        }
        
        let type = ClothesType.allCases[indexPath.section]
        let item = viewModel.dressArray.filter { $0.type == type }[indexPath.row]
        cell.configure(dress: item)
        return cell
    }
    
    func addSelectedCellWithSection(_ indexPath:IndexPath) -> IndexPath? {
        let existingIndexPath = selectedRows["\(indexPath.section)"]
        selectedRows["\(indexPath.section)"]=indexPath;
        return existingIndexPath
    }
    
    func indexPathIsSelected(_ indexPath:IndexPath) -> Bool {
        if let selectedIndexPathInSection = selectedRows["\(indexPath.section)"] {
            if(selectedIndexPathInSection.row == indexPath.row) { return true }
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! OutfitSelectCell
        
        let previusSelectedCellIndexPath = self.addSelectedCellWithSection(indexPath);
        
        if(previusSelectedCellIndexPath != nil) {
            let previusSelectedCell = self.tableView.cellForRow(at: previusSelectedCellIndexPath!) as! OutfitSelectCell
            
            previusSelectedCell.accessoryType = .none
            cell.accessoryType = .checkmark
            tableView.deselectRow(at: previusSelectedCellIndexPath!, animated: true)
        }
        else{
            cell.accessoryType = .checkmark
            
        }
        for selectedIndexPath: IndexPath in tableView.indexPathsForSelectedRows! {
            if selectedIndexPath.section == indexPath.section
            {
                cell.accessoryType = .checkmark
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        print(selectedRows)
    }
}
