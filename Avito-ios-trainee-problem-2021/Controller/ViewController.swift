//
//  ViewController.swift
//  Avito-ios-trainee-problem-2021
//
//  Created by Михаил Апанасенко 2 on 09.09.2021.
//

import UIKit

class ViewController: UIViewController, AvitoManagerDelegate {

    var manager = AvitoManager()
    var model: AvitoModel?
    let dateFormatter = DateFormatter()

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var refreshDataButton: UIButton!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "dd MMM 'в' HH:mm:ss"
        companyNameLabel.text = "Обновляется"
        lastUpdateLabel.isHidden = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: "EmployeeCell", bundle: nil), forCellReuseIdentifier: "EmployeeCell")
        manager.delegate = self
        manager.performRequest()
        
    }
    @IBAction func refreshPressed(_ sender: UIButton) {
        companyNameLabel.text = "Обновляется"
        lastUpdateLabel.isHidden = true
        manager.performRequest()
    }
    

    
    func didUpdateData(manager: AvitoManager, model: AvitoModel) {
        self.model = model
        self.model?.sortEmployees()
        DispatchQueue.main.async {
            self.companyNameLabel.text = self.model?.data.company.name
            self.lastUpdateLabel.isHidden = false
            self.lastUpdateLabel.text = "Последнее обновление: \(self.dateFormatter.string(from: Date()))" 
            self.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        if let error = error as? URLError, error.code == URLError.Code.networkConnectionLost || error.code == URLError.Code.notConnectedToInternet {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка сети", message: "Нет подключения к интернету\nПопробуйте позже", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Неизвестная ошибка", message: "Обратитесь к разработчику", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.data.company.employees.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let employee = model?.data.company.employees[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeCell
        cell.nameLabel.text = employee?.name
        cell.phoneLabel.text = employee?.phone_number
        cell.skillsLabel.text = employee?.skills.joined(separator: "\n")
        
        return cell
    }
    
    
}
