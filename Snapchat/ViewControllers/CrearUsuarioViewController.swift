import UIKit
import FirebaseAuth
import FirebaseDatabase

class CrearUsuarioViewController: UIViewController {

    @IBOutlet weak var nuevoEmailTextField: UITextField!
    @IBOutlet weak var nuevaPasswordTextField: UITextField!
    
    @IBAction func crearUsuarioTapped(_ sender: Any) {
        guard let nuevoEmail = nuevoEmailTextField.text, !nuevoEmail.isEmpty,
              let nuevaPassword = nuevaPasswordTextField.text, !nuevaPassword.isEmpty
        else {
            // Manejar el caso en que los campos estén vacíos
            mostrarAlerta(titulo: "Campos Vacíos", mensaje: "Por favor, ingresa un nuevo email y contraseña.", accion: "OK")
            return
        }

        // Crear el usuario en Firebase
        Auth.auth().createUser(withEmail: nuevoEmail, password: nuevaPassword) { [weak self] (user, error) in
            if let error = error {
                // Manejar el error al crear el usuario
                self?.mostrarAlerta(titulo: "Error al Crear Usuario", mensaje: error.localizedDescription, accion: "OK")
            } else {
                // Usuario creado exitosamente
                print("El usuario fue creado exitosamente")
                // Puedes realizar acciones adicionales aquí, como guardar información en la base de datos
                Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                // Cerrar la vista de creación de usuario y volver a la vista de inicio de sesión
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func cancelarTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
}
