#!/usr/bin/env python3
"""
Deployment Check Script for Be Her Best
Verifies that all deployment requirements are met
"""

import os
import sys
from pathlib import Path

def check_file_exists(filepath, description):
    """Check if a file exists and report status"""
    if os.path.exists(filepath):
        print(f"✅ {description}: {filepath}")
        return True
    else:
        print(f"❌ {description}: {filepath} - NOT FOUND")
        return False

def check_directory_structure():
    """Check if required directories exist"""
    base_path = Path(".")
    
    checks = [
        ("requirements.txt", "Requirements file"),
        ("render.yaml", "Render configuration"),
        ("Website/myproject", "Django project directory"),
        ("Website/myproject/requirements.txt", "Django requirements (if exists)"),
        ("Website/myproject/manage.py", "Django manage.py"),
        ("Website/myproject/myproject/settings.py", "Django settings"),
        (".env", "Environment variables file (if exists)")
    ]
    
    all_good = True
    print("=== DEPLOYMENT READINESS CHECK ===\n")
    
    for filepath, description in checks:
        if not check_file_exists(filepath, description):
            if filepath not in ["Website/myproject/requirements.txt", ".env"]:
                all_good = False
    
    print(f"\n=== RENDER CONFIGURATION CHECK ===")
    
    # Check render.yaml content
    if os.path.exists("render.yaml"):
        with open("render.yaml", "r") as f:
            content = f.read()
            if "branch: main" in content:
                print("✅ Render.yaml specifies main branch")
            else:
                print("❌ Render.yaml does not specify main branch")
                all_good = False
            
            if "pip install -r requirements.txt" in content:
                print("✅ Render.yaml has correct build command")
            else:
                print("❌ Render.yaml build command may be incorrect")
    
    print(f"\n=== SUMMARY ===")
    if all_good:
        print("🎉 All deployment requirements are met!")
        print("\nNext steps:")
        print("1. Ensure Render service is set to use 'main' branch")
        print("2. Trigger a new deployment in Render")
        print("3. Monitor the build logs")
    else:
        print("⚠️  Some issues need to be resolved before deployment")
    
    return all_good

if __name__ == "__main__":
    check_directory_structure()