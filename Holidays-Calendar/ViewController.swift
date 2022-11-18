//
//  ViewController.swift
//  Holidays-Calendar
//
//  Created by Hoàng Đức on 13/11/2022.
//

import UIKit


class ViewController: UIViewController{
    var listOfHolidays = [HolidayDetail]() {
        didSet {
            DispatchQueue.main.sync {
                self.tableView.reloadData()
                self.navigationItem.title = "\(self.listOfHolidays.count) Holidays Found"
            }
        }
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
   

    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
       title = "Holidays"
        navigationItem.searchController = searchController
        
        searchController.searchBar.placeholder = "Enter Country Code e.g. US"
        searchController.searchBar.delegate = self
        setUpTableView()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "HolidaysTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HolidaysTableViewCell")
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }


}
extension ViewController: UITableViewDelegate {
    
}
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfHolidays.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HolidaysTableViewCell", for: indexPath) as! HolidaysTableViewCell
        
        let holiday = listOfHolidays[indexPath.row]
        cell.textLabel?.text = holiday.name
        cell.detailTextLabel?.text = holiday.date.iso
        return cell
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        let holidayRequest = HolidayRequest(countryCode: searchBarText)
        holidayRequest.getHolidays {[weak self] result in
            switch result {
            case .failure(let erorr):
                print(erorr)
            case .success(let holidays):
                self?.listOfHolidays = holidays
            }
        }
    }
}

