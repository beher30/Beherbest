from setuptools import setup, find_packages

with open('requirements.txt') as f:
    requirements = f.read().splitlines()

setup(
    name="beherbest",
    version="1.0.0",
    packages=find_packages(),
    install_requires=requirements,
    python_requires='>=3.8',
    author="Your Name",
    author_email="your.email@example.com",
    description="BeHerBest - A Django-based web application",
    long_description=open('README.md').read(),
    long_description_content_type="text/markdown",
    url="https://github.com/beher30/Beherbest",
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3.10",
        "Framework :: Django :: 4.2",
    ],
    include_package_data=True,
    zip_safe=False,
)
