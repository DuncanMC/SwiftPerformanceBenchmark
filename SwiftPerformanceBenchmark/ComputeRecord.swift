//
//  ComputeRecord.swift
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 3/31/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import Foundation

class ComputeRecord: NSObject
{
  var totalToCalculate: Int = 2_000_000
  
  var doCalculationsInSwift: Bool = true
  var swift_totalCalculated: Int = 0
    {
    willSet(newValue)
    {
      self.willChangeValueForKey("swift_totalCalculated")
    }
    didSet(oldValue)
    {
      self.didChangeValueForKey("swift_totalCalculated")
    }
  }
  var swift_primesPerSecond: Int = 0
    {
    willSet(newValue)
    {
      self.willChangeValueForKey("swift_primesPerSecond")
    }
    didSet(oldValue)
    {
      self.didChangeValueForKey("swift_primesPerSecond")
    }
  }
  var swift_totalTime: NSTimeInterval = 0.0
  
  var doCalculationsInObjC: Bool = true
  var objC_totalCalculated: Int = 0
    {
    willSet(newValue)
    {
      self.willChangeValueForKey("objC_totalCalculated")
    }
    didSet(oldValue)
    {
      self.didChangeValueForKey("objC_totalCalculated")
    }
  }
  var objC_primesPerSecond: Int = 0
    {
    willSet(newValue)
    {
      self.willChangeValueForKey("objC_primesPerSecond")
    }
    didSet(oldValue)
    {
      self.didChangeValueForKey("objC_primesPerSecond")
    }
  }
  var objC_totalTime: NSTimeInterval = 0.0
}