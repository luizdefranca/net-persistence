//  CarsTableViewController.swift
//  Carangas

import UIKit

class CarsTableViewController: UITableViewController {

    //MARK: - Proprieties
    var cars : [Car] = [Car]()

    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "main")
        return label
    }()
    
    var connection : RestProtocol!
    
    //MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        connection = AFRest.shared
        tableView.dataSource = self
        label.text = "Loading data..."

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(fetchCars), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchCars()
        
    }
    
    //MARK: - User Functions


    @objc fileprivate func fetchCars() {
        
        
        connection.fetchCars { response in
            switch response {
                case .success(let cars):
                    
                    self.cars = cars
                    if cars.count == 0 {
                        DispatchQueue.main.async {
                            self.label.text = "No loaded data..."
                            self.tableView.backgroundView = self.label
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.refreshControl?.endRefreshing()
                            self.tableView.reloadData()
                        }
                    }
                    
                case .failure(let error): do {
                    DispatchQueue.main.async {
                        self.label.text = error.description
                        self.tableView.backgroundView = self.label
                        print(response)
                    }
                    print(response)
                }
            }
        }
       
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if cars.count == 0 {
            self.tableView.backgroundView = self.label
        } else {
            self.label.text = ""
            self.tableView.backgroundView = nil
        }
        return cars.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSegue", let vc = segue.destination as? CarViewController {
            guard let index = tableView.indexPathsForSelectedRows?.first?.row else {return}
            vc.car = cars[index]
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let row = indexPath.row
            let car = cars[row]
            connection.delete(car: car) { response in
               
                switch response {
                    case .success():
                        self.cars.remove(at: row)
                        DispatchQueue.main.async {
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    
                        //TODO: fazer mensage ao usario
                    case .failure(let error) :
                    print(error.description)
                }

            }

        }
    }
   
}

