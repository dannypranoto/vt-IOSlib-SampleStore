//
//  ViewController.swift
//  vt-IOSlib-SampleStore
//
//  Created by Danny Pranoto on 1/27/16.
//
//

import UIKit

class ViewController: UIViewController {
    let clientKey = "bb558bb6-371a-415b-b7ee-bf285f33868f"
    let vtDirect = VTDirect()
    
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var expYear: UITextField!
    @IBOutlet weak var expMonth: UITextField!
    @IBOutlet weak var creditCardNumber: UITextField!
    
    @IBAction func pay(sender: AnyObject) {
        let creditCardDetails = VTCardDetails()
        creditCardDetails.card_number = creditCardNumber.text
        creditCardDetails.card_cvv = cvv.text
        creditCardDetails.card_exp_month = Int(expMonth.text!)!
        creditCardDetails.card_exp_year = Int(expYear.text!)!
        creditCardDetails.gross_amount = "10000"
        creditCardDetails.secure = true
        vtDirect.card_details = creditCardDetails
        VTConfig.setCLIENT_KEY(clientKey)
        VTConfig.setVT_IsProduction(false)
        vtDirect.getToken{(token, exception) -> Void in
            if let vtToken: VTToken = token {
                if vtToken.redirect_url != nil {
                    //Tampilkan web view redirect_url - 3DS
                    print(vtToken);
                }
                else {
                    //charge transaction - non 3DS
                    print(vtToken);
                }
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

