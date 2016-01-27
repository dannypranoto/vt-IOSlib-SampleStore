//
//  ViewController.swift
//  vt-IOSlib-SampleStore
//
//  Created by Danny Pranoto on 1/27/16.
//
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    let clientKey = "PUT_YOUR_CLIENT_KEY_HERE"
    let merchantUrl = "PUT_YOUR_CHARGING_ENDPOINT_HERE"
    let totalPrice = "10000"
    let vtDirect = VTDirect()
    let cardDetails = VTCardDetails()
    var token: VTToken?
    
    @IBOutlet weak var creditCardNumber: UITextField!
    @IBOutlet weak var expMonth: UITextField!
    @IBOutlet weak var expYear: UITextField!
    @IBOutlet weak var cvv: UITextField!
    
    override func viewDidLoad() {
        // initialize client_key and veritrans environment
        VTConfig.setCLIENT_KEY(clientKey)
        VTConfig.setVT_IsProduction(false)
    }
    
    @IBAction func pay(sender: UIButton) {
        // get token and charge transaction
        acquiredCardDetails()
        vtDirect.card_details = cardDetails
        vtDirect.getToken{(token, exception) -> Void in
            if let vtToken: VTToken = token {
                self.token = token
                if vtToken.redirect_url != nil {
                    //Displaying redirect url in Web View - 3DS
                    let webView:UIWebView = UIWebView(frame: CGRectMake(0, 10, 320, 320))
                    webView.loadRequest(NSURLRequest(URL: NSURL(string:token.redirect_url)!))
                    webView.delegate = self
                    webView.scalesPageToFit = true;
                    webView.multipleTouchEnabled = false;
                    webView.contentMode = UIViewContentMode.ScaleAspectFit;
                    self.view.addSubview(webView)
                }
                else {
                    //charge transaction - non 3DS
                    self.chargeRequest("token-id=\(vtToken.token_id)")
                }
            } else {
                print("Unable to retrieve token")
            }
        }
    }
    
    @IBAction func registerCard(sender: UIButton) {
        // register user's card and exchange it with saved_token_id
        acquiredCardDetails()
        vtDirect.card_details = cardDetails
        vtDirect.registerCard{(savedToken, exception) -> Void in
            self.sendRegisteredCardToken(savedToken)
        }
    }
    
    func acquiredCardDetails() {
        // retrieve all user's credit card information from user interface and assign to cardDetails object
        cardDetails.card_number = creditCardNumber.text
        cardDetails.card_exp_month = Int(expMonth.text!)!
        cardDetails.card_exp_year = Int(expYear.text!)!
        cardDetails.card_cvv = cvv.text
        cardDetails.gross_amount = totalPrice
        cardDetails.secure = true
    }
    
    func sendRegisteredCardToken(serverResponse: NSData!) {
        // register user's card and exchange it with saved_token_id
        var jsonBody = JSON(data:serverResponse!)
        jsonBody["user_id"] = "A"
        if let body = jsonBody.rawString() {
            let request = generatePostRequest(merchantUrl, bodyData: body)
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
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // charge transaction after user has successfully authenticated by 3D Secure
        if(webView.request?.URL!.absoluteString.rangeOfString("callback") != nil){
            webView.removeFromSuperview()
            let bodyData = "token-id=\(self.token!.token_id)&price=\(totalPrice)"
            chargeRequest(bodyData)
        }
    }
    
    func chargeRequest(bodyData: String) {
        // sending charge request to merchant's server
        let request = generatePostRequest(merchantUrl, bodyData: bodyData)
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
    
    func generatePostRequest(merchantUrl: String, bodyData: String) -> NSMutableURLRequest {
        // generate HTTP post request
        let request = NSMutableURLRequest(URL: NSURL(string: merchantUrl)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

