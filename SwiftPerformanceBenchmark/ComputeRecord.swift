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
  var totalToCalculate: Int = 10000000
  
  var doCalculationsInSwift: Bool = true
  var swift_totalCalculated: Int = 0
  var swift_primesPerSecond: Int = 0
  var swift_totalTime: NSTimeInterval = 0.0
  
  var doCalculationsInObjC: Bool = true
  var objC_totalCalculated: Int = 0
  var objC_primesPerSecond: Int = 0
  var objC_totalTime: NSTimeInterval = 0.0
}