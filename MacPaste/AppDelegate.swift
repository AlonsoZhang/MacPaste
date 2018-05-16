//
//  AppDelegate.swift
//  MacPaste
//
//  Created by Alonso on 2018/5/10.
//  Copyright © 2018 Alonso. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,NSTableViewDelegate {
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var tableview: NSTableView!
    
    @objc dynamic var Copys:[[String:String]] = []
    @objc dynamic var Show = true
    @objc dynamic var firstname = 0
    
    let hotkey = JFHotkeyManager.init()
    var timer : Timer!
    let defaults = UserDefaults.standard
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AppDelegate.checkPasteboard), userInfo: nil, repeats: true)
        hotkey.bind("control v", target: self, action: #selector(AppDelegate.showhide))
        if (defaults.object(forKey: "COPY") != nil){
            Copys = defaults.object(forKey: "COPY") as! [[String : String]]
        }else{
            Copys = []
        }
        tableview.action = #selector(AppDelegate.singleaction)
        Show = false
        window.hidesOnDeactivate = true
    }
    
    @objc func showhide() {
//        if Show {
//            Show = false
//        }else{
            Show = true
            NSRunningApplication.current.activate(options: [.activateAllWindows,.activateIgnoringOtherApps])
        //}
    }
    
    @objc func checkPasteboard() {
        if let lastPasteboard =  NSPasteboard.general.string(forType:.string){
            if Copys.count > 0
            {
                if lastPasteboard != Copys.first!["Copy"]{
                    for onecopy in Copys.enumerated() {
                        if lastPasteboard == onecopy.element["Copy"]{
                            Copys.remove(at: onecopy.offset)
                        }
                    }
                    Copys.insert(["Copy":lastPasteboard], at: 0)
                    tableview.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
                }
            }else{
                Copys.insert(["Copy":lastPasteboard], at: 0)
            }
            defaults.set(Copys, forKey: "COPY")
            tableview.reloadData()
        }
    }
    
    @IBAction func clearhistory(_ sender: NSMenuItem) {
        Copys.removeAll()
        NSPasteboard.general.clearContents()
        defaults.set(Copys, forKey: "COPY")
    }
    
    @objc func singleaction() {
        let selectInt = self.tableview.selectedRow
        if selectInt > -1 {
            let copyinfo = Copys[selectInt]["Copy"]
            Copys.remove(at: selectInt)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.writeObjects([copyinfo! as NSPasteboardWriting])
            Show = false
            //control+F4,获取之前活动窗口
            press(functionkey: "control", keynum: 118)
            //command+v,粘贴
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
                self.press(functionkey: "command", keynum: 9)
            }
        }
    }
    
    func press(functionkey:String, keynum:Int) {
        var event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(keynum), keyDown: true)
        if functionkey == "control" {
            event?.flags = CGEventFlags.maskControl
        }else if functionkey == "command" {
            event?.flags = CGEventFlags.maskCommand
        }
        event?.post(tap: .cgSessionEventTap)
        event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(keynum), keyDown: false)
        event?.post(tap: .cgSessionEventTap)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func returnaction(_ sender: NSMenuItem) {
        singleaction()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        defaults.set(Copys, forKey: "COPY")
        return false
    }
}

