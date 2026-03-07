//
//  DBCIntensityLevel.h
//  Pods
//
//  Created by Jim Boyd on 7/22/16.
//
//


#ifndef __DBCINTENSITYLEVEL__
#define __DBCINTENSITYLEVEL__

/**
 Set "DBC_DebugIntensityLevel" to some value to execute intense intensity-gated messaging code.
 Allows you to enter intensity-gated messaging code at some level greater than zero.
 When you back off the intensity level, you can leave the code in place without
 execution until that intensity level is required again.
 
 "DBC_DebugIntensityLevel" defaults to zero. If a higher intensity level is required,
 it should be changed to the higher level in the debugger at runtime.
 
 Setting "DBC_DebugIntensityLevel to a value less than zero effectively turns intensity-gated messaging off
 for these calls
 */

@import Foundation;

#ifdef __cplusplus
extern "C" {
#endif
	
	extern NSInteger DBC_DebugIntensityLevel(void);
	extern void DBC_SetDebugIntensityLevel(NSInteger intensityLevel);
	
	/// Utility function to perform a provided closure `block` if `DBC_DebugIntensityLevel` is at or greater than the target `intensity` level.
	/// See `DBC_DebugIntensityLevel`.
	extern void DBC_performIfDBCIntensity(NSInteger intensity, void (^ _Nonnull block)(void));
	
#ifdef __cplusplus
}
#endif

#endif
