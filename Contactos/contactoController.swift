//
//  contactoController.swift
//  Contactos
//
//  Created by Mac2 on 21/11/20.
//  Copyright © 2020 Mac2. All rights reserved.
//

import UIKit
import CoreData

class contactoController: UIViewController {

    @IBOutlet weak var nombreTextFIeld: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contactos = [Contacto]()

    
    override func viewDidLoad() {
        cargarInfoCoreData()
        super.viewDidLoad()
        nombreTextFIeld.text = recibirNombre
        telefonoTextField.text = recibirTelefono
        direccionTextField.text = recibirDireccion
        // Do any additional setup after loading the view.
    }
    var recibirNombre: String?
    var recibirTelefono: String?
    var recibirDireccion: String?
    var recibirIndex: Int?
        
    func guardarContacto() {
        contactos[recibirIndex ?? 0].setValue(nombreTextFIeld.text, forKey: "nombre")
        contactos[recibirIndex ?? 0].setValue(Int64(telefonoTextField.text ?? ""), forKey: "telefono")
        contactos[recibirIndex ?? 0].setValue(direccionTextField.text, forKey: "direccion")
        do {
            try context.save()
            
            print("Guardar contacto")
            
        }catch let error as NSError {
            print(error)
        }
    }
    
    func cargarInfoCoreData(){
        
        let fetchrequest : NSFetchRequest <Contacto> = Contacto.fetchRequest()
        
        
        do{
            contactos = try context.fetch(fetchrequest)
            
        }catch let error as NSError{
            print("error al cargar info")
        }
    }

    @IBAction func eliminar(_ sender: UIButton) {
        let alert2 = UIAlertController(title: "¿Seguro que desea borrar el contacto?", message: "COnfirmacion", preferredStyle: .alert)
        
        
        let actionAceptar = UIAlertAction(title: "Eliminar", style: .destructive) { (_) in
            
            self.eliminarContacto(index: self.recibirIndex ?? 0)
            
        }
        let actionCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alert2.addAction(actionAceptar)
        alert2.addAction(actionCancelar)
        present(alert2, animated: true, completion: nil)
        
    }
    func eliminarContacto(index: Int) {
        context.delete(contactos[index])
        contactos.remove(at: index)
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("error : \(error)")
        }
    }
    
    
    @IBAction func guardarContactoButton(_ sender: UIButton) {
        var bandera = 0
        var campos = ""
        if nombreTextFIeld.text == "" {
            bandera = 1
            campos = "Nombre "
        }
        if telefonoTextField.text == "" {
            bandera = 1
            campos = campos+" Telefono"
        }
        if direccionTextField.text == "" {
            bandera = 1
            campos = campos+" Direccion"
        }
        if bandera == 1 {
            let alert2 = UIAlertController(title: "Los campos: "+campos+" se encuentran vacios", message: "Favor de llenarlos", preferredStyle: .alert)
            
            
            let actionAceptar = UIAlertAction(title: "Aceptar", style: .default)
            alert2.addAction(actionAceptar)
            present(alert2, animated: true, completion: nil)
        }else{
        let alert = UIAlertController(title: "Seguro que deseas guardar los cambios", message: "Confirmacion", preferredStyle: .alert)
        
        
        let actionAceptar = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            
        self.guardarContacto()
        self.navigationController?.popViewController(animated: true)
        }
        let actionCancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        
        alert.addAction(actionAceptar)
        alert.addAction(actionCancelar)
        
        present(alert, animated: true, completion: nil)
        
    }
    }
    @IBAction func cancelarButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
