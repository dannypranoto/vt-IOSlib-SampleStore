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
    var requestData: JSON?
    
    @IBOutlet weak var creditCardNumber: UITextField!
    @IBOutlet weak var expMonth: UITextField!
    @IBOutlet weak var expYear: UITextField!
    @IBOutlet weak var cvv: UITextField!
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // initialize client_key and veritrans environment
        VTConfig.setCLIENT_KEY(clientKey)
        VTConfig.setVT_IsProduction(false)
    }
    
    @IBAction func pay(sender: UIButton) {
        // get token and charge transaction
        acquiredCardDetails()
        vtDirect.card_details = cardDetails
        vtDirect.getToken{(responseData : NSData!, ex : NSException!) -> Void in
            if (ex == nil) {
                //checking response data nil or not
                if (responseData != nil) {
                    var requestData = JSON(data: responseData);
                    self.requestData = requestData
                    if (requestData["redirect_url"] != nil) {
                        //Displaying redirect url in Web View - 3DS
                        let webView:UIWebView = UIWebView(frame: CGRectMake(0, 10, 320, 320))
                        webView.loadRequest(NSURLRequest(URL: NSURL(string: requestData["redirect_url"].stringValue)!))
                        webView.delegate = self
                        webView.scalesPageToFit = true;
                        webView.multipleTouchEnabled = false;
                        webView.contentMode = UIViewContentMode.ScaleAspectFit;
                        self.view.addSubview(webView)
                    }
                    else {
                        //charge transaction - non 3DS
                        self.chargeRequest("token-id=\(requestData["token_id"].stringValue)")
                    }
                } else {
                    print("Unable to retrieve token")
                }

            } else {
                //Something is wrong, get details message by print ex.reason
                print(ex.reason)
            }
        }
    }
    
    @IBAction func registerCard(sender: UIButton) {
        // register user's card and exchange it with saved_token_id
        acquiredCardDetails()
        vtDirect.card_details = cardDetails
        vtDirect.registerCard{(responseData: NSData!, ex: NSException!) -> Void in
            if(ex == nil) {
                // checking response data nil or not
                self.sendRegisteredCardToken(responseData)
            } else {
                print(ex.reason);
            }
        }
    }
    
    func acquiredCardDetails() {
        // retrieve all user's credit card information from user interface and assign to cardDetails object
        cardDetails.card_number = creditCardNumber.text
        cardDetails.card_exp_month = expMonth.text
        cardDetails.card_exp_year = Int(expYear.text!)!
        cardDetails.card_cvv = cvv.text
        cardDetails.gross_amount = totalPrice
        cardDetails.secure = true
    }
    
    func sendRegisteredCardToken(serverResponse: NSData!) {
        // register user's card and exchange it with saved_token_id
        var jsonBody = JSON(data:serverResponse!)
        jsonBody["user_id"] = "PUT_YOUR_USER_ID_HERE"
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
            let bodyData = "token-id=\(self.requestData!["token_id"].stringValue)&price=\(totalPrice)"
            chargeRequest(bodyData)
        }
    }
    
    func chargeRequest(responseData: String) {
        // sending charge request to merchant's server
        let request = generatePostRequest(merchantUrl, bodyData: responseData)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            if (error == nil) {
                // if your server has successfully charge the transaction
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData!)")
            } else {
                // if your server has failed charge the transaction
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
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

