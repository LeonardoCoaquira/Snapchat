//
//  ViewController.swift
//  Snapchat
//
//  Created by Leonardo Coaquira on 7/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] (user, error) in
                    print("Intentando iniciar sesión")
                    if error != nil {
                        print("Se presentó el siguiente error: \(String(describing: error))")
                        self?.alertaUsuarioInvalido(titulo: "Error de Inicio de Sesion", mensaje: "El usuario no existe, ¿Desea crearlo?", accionCrear: "Crear", accionCancelar: "Cancelar", handlerCrear: { _ in
                            self?.performSegue(withIdentifier: "crearusuariosegue", sender: nil)
                        }, handlerCancelar: nil)
                    } else {
                        print("Inicio de sesión exitoso")
                        self?.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                    }
        }
    }
    
    @IBAction func loginGoogle(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            // ...
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

          // ...
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Error al iniciar sesión: \(error.localizedDescription)")
                } else {
                    print("Inicio de sesión exitoso")
                    // Aquí puedes realizar cualquier otra acción que necesites después de un inicio de sesión exitoso
                }
            }
        }
    }
    
    

    func alertaUsuarioInvalido(titulo: String, mensaje: String, accionCrear: String, accionCancelar: String, handlerCrear: ((UIAlertAction) -> Void)?, handlerCancelar: ((UIAlertAction) -> Void)?) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCrear = UIAlertAction(title: accionCrear, style: .default, handler: handlerCrear )
        let btnCancelar = UIAlertAction(title: accionCancelar, style: .cancel, handler: handlerCancelar )
        alerta.addAction(btnCrear)
        alerta.addAction(btnCancelar)
        present(alerta, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

