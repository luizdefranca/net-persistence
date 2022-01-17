//  AddEditViewController.swift
//  Carangas
//

import UIKit

enum CarOperationAction {
    case add_car
    case edit_car
    case get_brands
}

class AddEditViewController: UIViewController {

    //MARK: - Proprieties
    var car: Car!
    var brands: [Brand] = []
    lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self

        return picker
    } ()
    
    var connection : RestProtocol!

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    // MARK: - Lifecicle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        connection = AFRest.shared
        loadBrands()
        addToolBar()

        if car != nil {
            // modo edicao
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Alterar carro", for: .normal)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }


    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {

        if car == nil {
            // adicionar carro novo
            car = Car()
        }

        car.name = (tfName?.text)!
        car.brand = (tfBrand?.text)!
        if tfPrice.text!.isEmpty {
            tfPrice.text = "0"
        }

        car.price = Double(tfPrice.text!) ?? 0.0
        car.gasType = scGasType.selectedSegmentIndex

        if let _ = car._id  {
            updateCar()
        } else {
            addCar()
        }

    }

    @objc fileprivate func cancel() {
        tfBrand.resignFirstResponder()
    }

    @objc fileprivate func done() {
        tfBrand.text = brands[pickerView.selectedRow(inComponent: 0)].fipeName
        cancel()
    }


    fileprivate func addCar() {

        startLoadingAnimation()

        // new car
        connection.save(car: car) { result in
            
            switch result{
            case .success():
                self.goBack()
            case .failure(let error):
                // mostrar um erro generico
                self.showAlert(withTitle: "Failure Saving Car", withMessage: "Não foi possível adicionar o carro.", isTryAgain: true, operation: .add_car)
                print(error.description)
            }
        }
    }

    fileprivate func updateCar() {

        startLoadingAnimation()

        // 2 - edit current car
        connection.update(car: car) { result in
            
            switch result {
            case .success():
                self.goBack()
            case .failure(let error):
                self.showAlert(withTitle: "Failure Updating Car", withMessage: "Não foi possível editar o carro.", isTryAgain: true, operation: .edit_car)
                print(error.description)
            }
           
        }
    }

    fileprivate func addToolBar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [btCancel, btSpace, btDone]

        tfBrand.inputAccessoryView = toolbar
        tfBrand.inputView = pickerView
    }

    fileprivate func loadBrands() {

        connection.fetchBrands { response  in
            switch response {
            case .success(let brands):
                // ascending order
                self.brands = brands.sorted(by: {$0.fipeName < $1.fipeName})
                
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
            case .failure(let error):
                print("\(error.description) \nfile: \(#file) - function: \(#function) - line: \(#line)")
            }
        }
    }
    fileprivate func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

    fileprivate func showAlert(withTitle titleMessage: String, withMessage message: String, isTryAgain hasRetry: Bool, operation oper: CarOperationAction) {

        if oper != .get_brands {
            DispatchQueue.main.async {
                self.stopLoadingAnimation()
            }

        }

        let alert = UIAlertController(title: titleMessage, message: message, preferredStyle: .actionSheet)

        if hasRetry {
            let tryAgainAction = UIAlertAction(title: "Tentar novamente", style: .default, handler: {(action: UIAlertAction) in

                switch oper {
                    case .add_car:
                        self.addCar()
                    case .edit_car:
                        self.updateCar()
                    case .get_brands:
                        self.loadBrands()
                }

            })
            alert.addAction(tryAgainAction)

            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: {(action: UIAlertAction) in
                self.goBack()
            })
            alert.addAction(cancelAction)
        }

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func startLoadingAnimation() {
        self.btAddEdit.isEnabled = false
        self.btAddEdit.backgroundColor = .gray
        self.btAddEdit.alpha = 0.5
        self.loading.startAnimating()
    }

    func stopLoadingAnimation() {
        self.btAddEdit.isEnabled = true
        self.btAddEdit.backgroundColor = UIColor(named: "main")
        self.btAddEdit.alpha = 0
        self.loading.stopAnimating()
    }
} //End AddEditViewController

//MARK: - Extensions
extension AddEditViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        let brand = brands[row]
        return brand.fipeName
    }
}

extension AddEditViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  brands.count
    }

}

