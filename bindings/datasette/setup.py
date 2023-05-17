from setuptools import setup

version = {}
with open("datasette_sqlite_hello/version.py") as fp:
    exec(fp.read(), version)

VERSION = version['__version__']


setup(
    name="datasette-sqlite-hello",
    description="",
    long_description="",
    long_description_content_type="text/markdown",
    author="Alex Garcia",
    url="https://github.com/asg017/sqlite-hello",
    project_urls={
        "Issues": "https://github.com/asg017/sqlite-hello/issues",
        "CI": "https://github.com/asg017/sqlite-hello/actions",
        "Changelog": "https://github.com/asg017/sqlite-hello/releases",
    },
    license="MIT License, Apache License, Version 2.0",
    version=VERSION,
    packages=["datasette_sqlite_hello"],
    entry_points={"datasette": ["sqlite_hello = datasette_sqlite_hello"]},
    install_requires=["datasette", "sqlite-hello"],
    extras_require={"test": ["pytest"]},
    python_requires=">=3.6",
)
