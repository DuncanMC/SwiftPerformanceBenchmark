//
//  CalcPrimesObjC.h
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 3/31/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CalcPrimesProtocol.h"

@class ComputeRecord;

@interface CalcPrimesObjC : NSObject <CalcPrimesProtocol>
{
  NSTimeInterval startTime;
  ComputeRecord *theComputeRecord;
}

+ (instancetype) sharedInstance;

@end
