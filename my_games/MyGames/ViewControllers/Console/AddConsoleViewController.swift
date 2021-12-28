//
//  AddConsoleViewController.swift
//  MyGames
//
//  Created by Luiz Carlos F Ramos on 17/05/21.
//

import UIKit
import Photos

class AddConsoleViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tfNome: UITextField!
    
    @IBOutlet weak var ivLogo: UIImageView!

    //MARK: - Delegates
    weak var delegate: AddEditGameProtocol?
    
    
    //MARK: - Proprieties
    var logo = UIImage(named: "console")
    var originViewController : UIViewController = UIViewController()
    
    private func chooseImageFromLibrary(sourceType: UIImagePickerController.SourceType) {
        
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.tintColor = UIColor(named: "main")
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                    self.chooseImageFromLibrary(sourceType: sourceType)
                    
                } else {
                    
                    print("unauthorized -- TODO message")
                }
            })
        } else if photos == .authorized {
            self.chooseImageFromLibrary(sourceType: sourceType)
        } else if photos == .denied {
            print("unauthorized -- TODO message")
            
            //TODO: mostrar ym dialogo para convencer o usuario para dar permissao manualmente
        }
    }
    
    
    @IBAction func saveConsole(_ sender: Any) {

        let nome = tfNome.text
        logo = ivLogo.image
        ConsolesManager.shared.saveConsole(in: context, withName: nome!, andLogo: logo!)

      
        
        
        
        if self.originViewController .isKind(of: AddEditGameViewController.self){
            delegate?.uploadData()
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            dismiss(animated: true, completion: nil)
        } else {

            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func AddLogo(_ sender: UIButton) {
        // para adicionar uma imagem da biblioteca
        print("para adicionar uma imagem da biblioteca")
        
        
        let alert = UIAlertController(title: "Selecionar o logo", message: "De onde você quer escolher o logo?", preferredStyle: .actionSheet)
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Album de fotos", style: .default, handler: {(action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        })
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
      present(alert, animated: true, completion: nil)
        
    }
    
    
}


extension AddConsoleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // tip. implementando os 2 protocols o evento sera notificando apos user selecionar a imagem
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.ivLogo.image = pickedImage
                self.ivLogo.setNeedsDisplay()
                
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
