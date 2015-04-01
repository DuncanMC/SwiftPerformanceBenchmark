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
  
  //weak var progressTimer: NSTimer?
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
  var calculationsRunning: Bool = false
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
      !calculationsRunning &&
      (
        theComputeSettings.doCalculationsInSwift ||
          theComputeSettings.doCalculationsInObjC)
  }
  
  //-------------------------------------------------------------------------------------------------------
  
  @IBAction func CalculatePrimes(sender: NSButton)
  {
    println("In \(__FUNCTION__)")
    primesToCalculateField.window?.makeFirstResponder(nil)
    progressIndicator.doubleValue = 0;
    calculateButton.enabled = false
    
    //This code calculates primes using the Objective-C code.
    theComputeSettings.objC_totalCalculated = 0;
    theComputeSettings.objC_primesPerSecond = 0;
    theComputeSettings.objC_totalTime = 0;
    calculationsRunning = true;
    dispatch_async(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
      {
        [weak self] in
        if let requiredSelf = self
        {
          let theCalcPrimesObjC:CalcPrimesProtocol = CalcPrimesObjC.sharedInstance();
          let theCalcPrimesSwift:CalcPrimesProtocol = CalcPrimesSwift.sharedInstance();

          theCalcPrimesObjC.calcPrimesWithComputeRecord(requiredSelf.theComputeSettings,
            withUpdateDisplayBlock:
            {
              //println("In updateDisplayBlock")
              let progressValue =  Double(requiredSelf.theComputeSettings.objC_totalCalculated)/Double(requiredSelf.theComputeSettings.totalToCalculate) * Double(1000)
              
              if requiredSelf.theComputeSettings.objC_totalCalculated == requiredSelf.theComputeSettings.totalToCalculate
              {
                requiredSelf.calculationsRunning = false;
              }
              
              requiredSelf.progressIndicator.doubleValue = progressValue
              requiredSelf.showSettings(requiredSelf)
            },
          andCompletionBlock:
            {
              println("In completion block")
            }
          )
        }
      }
    )
  }
}

