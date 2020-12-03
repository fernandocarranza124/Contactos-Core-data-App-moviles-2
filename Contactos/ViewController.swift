

import UIKit
import CoreData

class ViewController: UIViewController {
    var nombreContacto: String?
    var telefonoContacto:String?
    var direccionContacto: String?
    var contactos = [Contacto]()
    var index: Int?
    func conexion()->NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tablaContactos: UITableView!

    
    
    override func viewDidLoad() {
        self.cargarInfoCoreData()
        self.tablaContactos.reloadData()
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.cargarInfoCoreData()
        self.tablaContactos.reloadData()
    }
    
    @IBAction func segundaPantalla(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "other") as! contactoController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    func cargarInfoCoreData(){
        let contextp = conexion()
        let fetchrequest : NSFetchRequest <Contacto> = Contacto.fetchRequest()
        

        do{
            contactos = try contextp.fetch(fetchrequest)
            
        }catch let error as NSError{
            print("error al cargar info")
        }
    }
    

    @IBAction func agregarContacto(_ sender: UIBarButtonItem?) {
        agregarContactoPublic()
        
    }
    func agregarContactoPublic(){
        let alert = UIAlertController(title: "Agregar Contacto", message: "Nuevo Contacto", preferredStyle: .alert)
        
        alert.addTextField { (nombreAlert) in
            nombreAlert.placeholder = "Nombre"
        }
        
        alert.addTextField { (telefonoAlert) in
            telefonoAlert.placeholder = "Telefono"
        }
        
        alert.addTextField { (direccionAlert) in
            direccionAlert.placeholder = "Direccion"
        }
        

        
        let actionAceptar = UIAlertAction(title: "Aceptar", style: .default) { (_) in
            
            
            guard let nombreAlert = alert.textFields?.first?.text else { return }
            guard let telefonoAlert = alert.textFields?[1].text else { return }
            guard let direccionAlert = alert.textFields?.last?.text else { return }
            let imagen = #imageLiteral(resourceName: "UserDefault")
            if nombreAlert == "" || telefonoAlert == "" || direccionAlert == ""
            {
                let alert2 = UIAlertController(title: "No se ha podido guardar debido a que algun campo estaba vacio", message: "favor de llenarlo", preferredStyle: .alert)
                
                let actionAceptar = UIAlertAction(title: "Volver a llenar", style: .default){ (_) in self.agregarContactoPublic()}
                let actionCancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
                alert2.addAction(actionAceptar)
                alert2.addAction(actionCancelar)
                self.present(alert2, animated: true, completion: nil)
            }else{
            
            let contexto = self.conexion()
            let entidadContacto = NSEntityDescription.insertNewObject(forEntityName: "Contacto", into: contexto) as! Contacto
            entidadContacto.nombre = nombreAlert
            entidadContacto.telefono  = Int64(telefonoAlert)!
            entidadContacto.direccion = direccionAlert
            entidadContacto.imagen = imagen.jpegData(compressionQuality: 1)
            
            do {
                try contexto.save()
                self .cargarInfoCoreData()
                print("Agregar contacto")
                self.tablaContactos.reloadData()
            }catch let error as NSError {
                print(error)
            }
        }
        }
        let actionCancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        
        alert.addAction(actionAceptar)
        alert.addAction(actionCancelar)
        
        present(alert, animated: true, completion: nil)
    }
    func guardarContacto() {
        do {
            try context.save()
            self .cargarInfoCoreData()
            print("Agregar contacto")
            self.tablaContactos.reloadData()
        }catch let error as NSError {
            print(error)
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaContactos.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        celda.textLabel?.text = contactos[indexPath.row].nombre
        celda.detailTextLabel?.text = String(contactos[indexPath.row].telefono ?? 0)
        
        
        return celda
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
       
       nombreContacto = contactos[indexPath.row].nombre
        telefonoContacto = String(contactos[indexPath.row].telefono)
        direccionContacto = contactos[indexPath.row].direccion
        index = indexPath.row
        performSegue(withIdentifier: "editarContacto", sender: "nil")
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarContacto" {
            let objContacto = segue.destination as! contactoController
            objContacto.recibirNombre = nombreContacto
            objContacto.recibirTelefono = telefonoContacto
            objContacto.recibirDireccion = direccionContacto
            objContacto.recibirIndex = index
        }
    }
    
    
}
