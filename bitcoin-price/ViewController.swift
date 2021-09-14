//
//  ViewController.swift
//  bitcoin-price
//
//  Created by Renan Figueiredo Carneiro on 03/09/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var precoBitcoin: UILabel!
    @IBOutlet weak var atualizarButton: UIButton!
    
    @IBAction func atualizarPreco(_ sender: Any) {
        self.recuperaPreco()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.recuperaPreco()
    }
    func formataPreco(preco: NSNumber) -> String{
        let ns = NumberFormatter()
        ns.numberStyle = .decimal
        ns.locale = Locale(identifier: "pt_BR")
        
        if let precoFinal = ns.string(from: preco) {
            return precoFinal
        }
        
        return "0,00"
    }

    func recuperaPreco() {
        self.atualizarButton.setTitle("Atualizando...", for: .normal)
        if let url = URL(string: "https://blockchain.info/pt/ticker") {
            let tarefa  = URLSession.shared.dataTask(with: url) { (dados, requisicao, erro) in
                if erro == nil {
                    if let retorno = dados {
                        do{
                            if let objetoJson = try JSONSerialization.jsonObject(with: retorno, options: []) as? [String: Any] {
                                if let brl = objetoJson["BRL"] as? [String: Any] {
                                    print(brl)
                                    if let preco = brl["buy"] as? Double{
                                        let precoFormatado = self.formataPreco(preco: NSNumber(value: preco))
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.precoBitcoin.text = "R$ " + precoFormatado
                                            self.atualizarButton.setTitle("Atualizar", for: .normal)
                                        })
                                    }
                                }
                            }
                        }catch{
                            print("erro no retorno")
                        }
                    }
                }else {
                    print("erro na consulta")
                }
            }
            tarefa.resume()
        }
        
    }
    
    
}

