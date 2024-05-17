//
//  OutfitSelectVC.swift
//  OutfitPlannerApp
//
//  Created by Chingiz on 17.05.24.
//

import UIKit

class OutfitSelectVC: UIViewController {
    
    private let viewModel = OutfitSelectViewModel()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OutfitSelectCell.self, forCellReuseIdentifier: OutfitSelectCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
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
    }
    
    @objc
    private func didTapNextButton() {
        
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
        let value = viewModel.dressArray.filter ({ $0.type == ClothesType.allCases[section]}).count
        print(value)
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OutfitSelectCell.identifier, for: indexPath) as? OutfitSelectCell else { fatalError() }
        
        let type = ClothesType.allCases[indexPath.section]
        let item = viewModel.dressArray.filter { $0.type == type }[indexPath.row]
        cell.configure(dress: item)
        return cell
    }
}
