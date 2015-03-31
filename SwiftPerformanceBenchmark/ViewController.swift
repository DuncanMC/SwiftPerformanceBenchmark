//
//  ViewController.swift
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 3/31/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import Cocoa


class ViewController: NSViewController
{
  
  weak var progressTimer: NSTimer?
  //-------------------------------------------------------------------------------------------------------
  // MARK: - IBOutlets -
  //-------------------------------------------------------------------------------------------------------


  @IBOutlet weak var primesToCalculateField: NSTextField!
  
  @IBOutlet weak var totalCalcdSwiftField: NSTextField!
  @IBOutlet weak var primesPerSecSwiftField: NSTextField!
  @IBOutlet weak var totalTimeSwiftField: NSTextField!
  
  @IBOutlet weak var totalCalcdObjCField: NSTextField!
  @IBOutlet weak var primesPerSecObjCField: NSTextField!
  @IBOutlet weak var totalTimeObjCField: NSTextField!
  
  @IBOutlet weak var computeInSwiftCheckbox: NSButton!
  @IBOutlet weak var computeInObjCCheckbox: NSButton!
  
  @IBOutlet weak var calculateButton: NSButton!
  @IBOutlet weak var progressIndicator: NSProgressIndicator!
 
  //-------------------------------------------------------------------------------------------------------
  // MARK: - Other Properties -
  //-------------------------------------------------------------------------------------------------------

  var theComputeSettings: ComputeRecord = ComputeRecord()
    {
    didSet(oldValue)
    {
      self.showSettings(self)
    }
  }
  
  //-------------------------------------------------------------------------------------------------------

  var foo: Int = 12

  //-------------------------------------------------------------------------------------------------------
  
  var startTime: NSTimeInterval?
  
  //-------------------------------------------------------------------------------------------------------
  // MARK: - View controller methods -
  //-------------------------------------------------------------------------------------------------------
  
  override func viewDidLoad()
  {
    self.showSettings(self)
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  //-------------------------------------------------------------------------------------------------------

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }

  //-------------------------------------------------------------------------------------------------------
  // MARK: - IBAction methods -
  //-------------------------------------------------------------------------------------------------------
  
  @IBAction func showSettings(sender: AnyObject)
  {
    totalTimeSwiftField.stringValue = intervalAsHHMMSS(theComputeSettings.swift_totalTime)
    totalTimeObjCField.stringValue = intervalAsHHMMSS(theComputeSettings.objC_totalTime)
    calculateButton.enabled =
      progressTimer == nil &&
      (
      theComputeSettings.doCalculationsInSwift ||
      theComputeSettings.doCalculationsInObjC)
  }
  
  //-------------------------------------------------------------------------------------------------------
  
  func updateProgress(timer: NSTimer)
  {
    //println("In \(__FUNCTION__)")
    progressIndicator.doubleValue += progressIndicator.maxValue/25.0
    if progressIndicator.doubleValue >= progressIndicator.maxValue
    {
      progressIndicator.doubleValue = 0;
      progressTimer?.invalidate()
      progressTimer = nil
      self.showSettings(self)
    }
  }

  //-------------------------------------------------------------------------------------------------------
  
  @IBAction func CalculatePrimes(sender: NSButton)
  {
    println("In \(__FUNCTION__)")
    progressIndicator.doubleValue = 0;
    calculateButton.enabled = false

    progressTimer = NSTimer.scheduledTimerWithTimeInterval(
      0.1,
      target: self,
      selector: "updateProgress:",
    userInfo: nil,
    repeats: true)
    let time: NSTimeInterval = NSDate().timeIntervalSinceReferenceDate
  }
}

