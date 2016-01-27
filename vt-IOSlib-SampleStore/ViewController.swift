//
//  ViewController.swift
//  vt-IOSlib-SampleStore
//
//  Created by Danny Pranoto on 1/27/16.
//
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    let clientKey = "bb558bb6-371a-415b-b7ee-bf285f33868f"
    let merchantUrl = "http://requestb.in/10yhnrn1"
    let totalPrice = "10000"
    let vtDirect = VTDirect()
    var token: VTToken?
    
    @IBOutlet weak var cvv: UITextField!
    @IBOutlet weak var expYear: UITextField!
    @IBOutlet weak var expMonth: UITextField!
    @IBOutlet weak var creditCardNumber: UITextField!
    
    // MARK: Get Token
    
    @IBAction func pay(sender: AnyObject) {
        let creditCardDetails = VTCardDetails()
        creditCardDetails.card_number = creditCardNumber.text
        creditCardDetails.card_cvv = cvv.text
        creditCardDetails.card_exp_month = Int(expMonth.text!)!
        creditCardDetails.card_exp_year = Int(expYear.text!)!
        creditCardDetails.gross_amount = totalPrice
        creditCardDetails.secure = false
        vtDirect.card_details = creditCardDetails
        VTConfig.setCLIENT_KEY(clientKey)
        VTConfig.setVT_IsProduction(false)
        vtDirect.getToken{(token, exception) -> Void in
            if let vtToken: VTToken = token {
                self.token = token
                if vtToken.redirect_url != nil {
                    //Tampilkan web view redirect_url - 3DS
                    print(vtToken);
                }
                else {
                    //charge transaction - non 3DS
                    self.sendToken("token-id=\(vtToken.token_id)")
                }
            }
        }
        
    }
    
    // MARK: Card Register
    
    func sendRegisteredCardToken(serverResponse: NSData!) {
        let requestBody = NSString(data: serverResponse!, encoding: NSUTF8StringEncoding)
        if let body = requestBody {
            let request = generatePostRequest(merchantUrl, bodyData: body as String)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
                if (error == nil) {
                    print("Success")
                }
            })
            task.resume()
        } else {
            print("Unable to parse")
        }
    }
    
    // MARK: Send token to merchant server
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if(webView.request?.URL!.absoluteString.rangeOfString("callback") != nil){
            //remove webview from parent
            webView.removeFromSuperview();
            
            
            let bodyData = "token-id=\(self.token!.token_id)&price=\(totalPrice)"
            let request = generatePostRequest(merchantUrl, bodyData: bodyData)
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if(error == nil){
                    let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Body: \(strData!)")
                    let json = JSON(data:data!)
                    let success = json["status"].stringValue
                    if (success == "success"){
                        let trxId = json["body"]["transaction_id"]
                        print("Success to Charging data with transaction id\(trxId)")
                    } else {
                        print("Failed to Charge")
                    }
                } else {
                    print("Error: \(error!.localizedDescription)")
                }
                
            })
            task.resume()
        }
    }
    
    func sendToken(tokenId: String) {
        let request = generatePostRequest(merchantUrl, bodyData: tokenId)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            if (error == nil) {
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData!)")
                let json = JSON(data:data!)
                let success = json["status"].stringValue
                if (success == "success"){
                    let trxId = json["body"]["transaction_id"]
                    print("Success to Charging data with transaction id\(trxId)")
                } else {
                    print("Failed to Charge")
                }
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        })
        task.resume()
    }
    
    // MARK: Utilities
    
    func generatePostRequest(merchantUrl: String, bodyData: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: merchantUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

