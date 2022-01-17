//  CarViewController.swift
//  Carangas

import UIKit
import WebKit

class CarViewController: UIViewController {

    // MARK: - Proprieties
    var car: Car!

    // MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var aivLoading: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configScreen()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AddEditViewController
        vc?.car = car
    }

    // MARK: - Config View Methods
    fileprivate func configScreen() {
        title = car.name
        lbBrand.text = car.brand
        lbGasType.text = car.gas
        lbPrice.text = "\(car.price)"
        aivLoading.startAnimating()
        aivLoading.hidesWhenStopped = true
        aivLoading.color = UIColor.init(named: "main")
        showCarOnWebKit()
    }
    fileprivate func showCarOnWebKit() {

        let name = (car.name + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
        let scappedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://www.google.com.br/search?q=\(scappedName)&tbm=isch"
       
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url)

        // permite usar usar gestos para navegar
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true // preview usando 3D touch
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
    }

} //end CarViewController

 
//MARK: - Extensions
extension CarViewController: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("stopLoading")
        aivLoading.stopAnimating()
        
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        aivLoading.stopAnimating()
    }

}
