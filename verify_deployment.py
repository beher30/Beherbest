#!/usr/bin/env python3
"""
Deployment verification script for Be Her Best website
This script checks if all required files and configurations are ready for deployment
"""
import os
import sys

def check_file_exists(file_path, description):
    """Check if a file exists and print status"""
    if os.path.exists(file_path):
        print(f"✅ {description}: {file_path}")
        return True
    else:
        print(f"❌ {description}: {file_path} - NOT FOUND")
        return False

def check_directory_exists(dir_path, description):
    """Check if a directory exists and print status"""
    if os.path.exists(dir_path) and os.path.isdir(dir_path):
        print(f"✅ {description}: {dir_path}")
        return True
    else:
        print(f"❌ {description}: {dir_path} - NOT FOUND")
        return False

def verify_deployment_readiness():
    """Verify all deployment requirements"""
    print("🔍 Verifying Be Her Best Deployment Readiness")
    print("=" * 60)
    
    issues = 0
    
    # Check essential files
    essential_files = [
        ("requirements.txt", "Python dependencies"),
        ("render.yaml", "Render deployment configuration"),
        ("runtime.txt", "Python runtime version"),
        ("Website/myproject/manage.py", "Django management script"),
        ("Website/myproject/myproject/settings.py", "Django settings"),
        ("Website/myproject/myproject/wsgi.py", "WSGI application"),
        (".env", "Environment variables (development)"),
        ("README.md", "Project documentation")
    ]
    
    for file_path, description in essential_files:
        if not check_file_exists(file_path, description):
            issues += 1
    
    # Check essential directories
    essential_dirs = [
        ("Website/myproject/myapp", "Django application"),
        ("Website/myproject/myapp/templates", "Django templates"),
        ("Website/myproject/myapp/static", "Static files"),
        ("Website/myproject/myapp/migrations", "Database migrations")
    ]
    
    for dir_path, description in essential_dirs:
        if not check_directory_exists(dir_path, description):
            issues += 1
    
    print("\n" + "=" * 60)
    
    # Check requirements.txt content
    if os.path.exists("requirements.txt"):
        with open("requirements.txt", "r") as f:
            content = f.read()
            if "Django" in content and "gunicorn" in content:
                print("✅ Requirements.txt contains Django and Gunicorn")
            else:
                print("⚠️ Requirements.txt might be missing essential dependencies")
                issues += 1
    
    # Check render.yaml content
    if os.path.exists("render.yaml"):
        with open("render.yaml", "r") as f:
            content = f.read()
            if "buildCommand" in content and "startCommand" in content:
                print("✅ Render.yaml contains build and start commands")
            else:
                print("⚠️ Render.yaml might be missing essential commands")
                issues += 1
    
    print("\n" + "=" * 60)
    
    if issues == 0:
        print("🎉 SUCCESS: All deployment requirements verified!")
        print("✅ Your Be Her Best website is ready for deployment!")
        print("\n📝 Next steps:")
        print("1. Go to Render dashboard")
        print("2. Connect your GitHub repository: beher30/Beherbest")
        print("3. Render will automatically deploy using render.yaml")
        return True
    else:
        print(f"❌ ISSUES FOUND: {issues} problems need to be resolved")
        print("Please fix the missing files/directories before deployment")
        return False

if __name__ == "__main__":
    success = verify_deployment_readiness()
    sys.exit(0 if success else 1)