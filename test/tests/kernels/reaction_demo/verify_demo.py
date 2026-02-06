#!/usr/bin/env python3
"""
Simple verification script for the AD Reaction Kernel Demo
This script checks that the demo files are properly structured
and contain the expected components.
"""

import os
import sys

def check_file_exists(filepath, description):
    """Check if a file exists"""
    if os.path.exists(filepath):
        print(f"✓ {description}: {filepath}")
        return True
    else:
        print(f"✗ {description}: {filepath} (MISSING)")
        return False

def check_file_contains(filepath, patterns, description):
    """Check if a file contains expected patterns"""
    if not os.path.exists(filepath):
        print(f"✗ {description}: {filepath} (MISSING)")
        return False
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    missing = []
    for pattern in patterns:
        if pattern not in content:
            missing.append(pattern)
    
    if missing:
        print(f"✗ {description}: {filepath} (missing patterns: {missing})")
        return False
    else:
        print(f"✓ {description}: {filepath}")
        return True

def main():
    """Main verification function"""
    print("=== AD Reaction Kernel Demo Verification ===\n")
    
    base_dir = "/home/engine/project/test/tests/kernels/reaction_demo"
    inc_dir = "/home/engine/project/test/include/kernels"
    src_dir = "/home/engine/project/test/src/kernels"
    
    checks_passed = 0
    total_checks = 0
    
    # Check directory structure
    total_checks += 1
    if check_file_exists(base_dir, "Demo directory"):
        checks_passed += 1
    
    # Check header files
    total_checks += 1
    if check_file_exists(f"{inc_dir}/DemoReaction.h", "Manual reaction kernel header"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_contains(f"{inc_dir}/DemoReaction.h", 
                           ["class DemoReaction", "computeQpResidual", "computeQpJacobian"],
                           "Manual reaction kernel header content"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_exists(f"{inc_dir}/ADDemoReaction.h", "AD reaction kernel header"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_contains(f"{inc_dir}/ADDemoReaction.h",
                           ["class ADDemoReaction", "computeQpResidual"],
                           "AD reaction kernel header content"):
        checks_passed += 1
    
    # Check source files
    total_checks += 1
    if check_file_exists(f"{src_dir}/DemoReaction.C", "Manual reaction kernel source"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_contains(f"{src_dir}/DemoReaction.C",
                           ["registerMooseObject", "DemoReaction", "computeQpResidual", "computeQpJacobian"],
                           "Manual reaction kernel source content"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_exists(f"{src_dir}/ADDemoReaction.C", "AD reaction kernel source"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_contains(f"{src_dir}/ADDemoReaction.C",
                           ["registerMooseObject", "ADDemoReaction", "computeQpResidual"],
                           "AD reaction kernel source content"):
        checks_passed += 1
    
    # Check input files
    total_checks += 1
    if check_file_exists(f"{base_dir}/steady_reaction.i", "Steady-state input file"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_contains(f"{base_dir}/steady_reaction.i",
                           ["DemoReaction", "ADDemoReaction", "reaction_rate"],
                           "Steady-state input content"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_exists(f"{base_dir}/transient_reaction.i", "Transient input file"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_exists(f"{base_dir}/jacobian_test.i", "Jacobian test input file"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_exists(f"{base_dir}/reaction_only.i", "Reaction-only input file"):
        checks_passed += 1
    
    # Check test specifications
    total_checks += 1
    if check_file_exists(f"{base_dir}/tests", "Test specifications file"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_contains(f"{base_dir}/tests",
                           ["PetscJacobianTester", "Exodiff", "DemoReaction"],
                           "Test specifications content"):
        checks_passed += 1
    
    # Check documentation
    total_checks += 1
    if check_file_exists(f"{base_dir}/README.md", "README documentation"):
        checks_passed += 1
    
    total_checks += 1
    if check_file_exists(f"{base_dir}/demo_analysis.md", "Mathematical analysis"):
        checks_passed += 1
    
    # Summary
    print(f"\n=== Summary ===")
    print(f"Checks passed: {checks_passed}/{total_checks}")
    
    if checks_passed == total_checks:
        print("✓ All checks passed! The AD Reaction Kernel Demo is properly structured.")
        return 0
    else:
        print("✗ Some checks failed. Please review the implementation.")
        return 1

if __name__ == "__main__":
    sys.exit(main())