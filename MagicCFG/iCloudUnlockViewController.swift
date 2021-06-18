//
//  iCloudUnlockViewController.swift
//  MagicCFG
//
//  Created by Jan Fabel on 02.07.20.
//  Copyright © 2020 Jan Fabel. All rights reserved.
//

import Cocoa
import ORSSerial

class iCloudUnlockViewController: NSViewController, NSTextFieldDelegate, ORSSerialPortDelegate {
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        dismiss(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        QuitBTN_O.isHidden = true
        NewSerialField.delegate = self
        NewWifiField.delegate = self
        NewBMacField.delegate = self
        // Do view setup here.
    }
    @IBAction func Cancel(_ sender: Any) {
        //port.close()
        self.dismiss(sender)
    }
    func controlTextDidChange(_ obj: Notification) {
        let characterSet: NSCharacterSet = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-_:").inverted as NSCharacterSet
        let wifiSet: NSCharacterSet = NSCharacterSet(charactersIn: "abcdefABCDEF0123456789").inverted as NSCharacterSet
        self.NewSerialField.stringValue =  (self.NewSerialField.stringValue.components(separatedBy: characterSet as CharacterSet) as NSArray).componentsJoined(by: "").uppercased()
        
        self.NewWifiField.stringValue = String((self.NewWifiField.stringValue.components(separatedBy: wifiSet as CharacterSet) as NSArray).componentsJoined(by: "").uppercased().pairs.joined(separator: ":")[...16])
        
        self.NewBMacField.stringValue = String((self.NewBMacField.stringValue.components(separatedBy: wifiSet as CharacterSet) as NSArray).componentsJoined(by: "").uppercased().pairs.joined(separator: ":")[...16])
        
    }
    
    
    @IBOutlet weak var NewSerialField: NSTextField!
    @IBOutlet weak var NewWifiField: NSTextField!
    @IBOutlet weak var NewBMacField: NSTextField!
    @IBOutlet weak var UnlockDeviceBTN_O: NSButton!
    @IBOutlet weak var CancelBTN: NSButton!
    
    
    // This is just a flashing of the previosly entered Serial, WMac and BMac. Basically useless since u can also do this over the main interface
    
    @IBAction func UnlockDevice(_ sender: Any) {
        all_log = ""
        CancelBTN.isEnabled = false
        UnlockDeviceBTN_O.isEnabled = false
        NewSerialField.isEnabled = false
        NewWifiField.isEnabled = false
        NewBMacField.isEnabled = false
        let testCommand = ("".data(using: .utf8)! + Data([0x0A]))
        port.send(testCommand)
        delay(bySeconds: 1) {
        if all_log != "" {
            do {
                var value = self.NewSerialField.stringValue
                value.removeDangerousCharsForSYSCFG()
                let command = "syscfg add SrNm \(value)".data(using: .utf8)! + Data([0x0A])
                port.send(command)
            }
            do {
               // needs hex, under development
                var value = self.NewWifiField.stringValue
               value.removeDangerousCharsForSYSCFG()
               value = parseMactoMacHex(hex: value)
               let command = "syscfg add WMac \(value)".data(using: .utf8)! + Data([0x0A])
               port.send(command)
            }
            do {
               // needs hex, under development
                var value = self.NewBMacField.stringValue
               value.removeDangerousCharsForSYSCFG()
               value = parseMactoMacHex(hex: value)
               let command = "syscfg add BMac \(value)".data(using: .utf8)! + Data([0x0A])
               port.send(command)
            }
            self.NewSerialField.isEnabled = true
            self.NewWifiField.isEnabled = true
            self.NewBMacField.isEnabled = true
            self.UnlockDeviceBTN_O.isHidden = true
            self.QuitBTN_O.isHidden = false

        } else {
            self.NewSerialField.isEnabled = true
            self.NewWifiField.isEnabled = true
            self.NewBMacField.isEnabled = true
            self.UnlockDeviceBTN_O.isEnabled = true
            self.CancelBTN.isEnabled = true
            let alert = NSAlert()
            alert.messageText = "No device connected"
            alert.informativeText = "Please check your usb connection and try again. Make sure the device is in purple mode"
            alert.beginSheetModal(for: self.view.window!) { (reponse) in
                print("Alert sent...")

            }
            print("Connection error")
           
            }
        }
    }

    @IBOutlet weak var QuitBTN_O: NSButton!
    @IBAction func QuitBTN(_ sender: Any) {
        self.dismiss(sender)
    }
    
}
