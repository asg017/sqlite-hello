module github.com/asg017/sqlite-hello/examples/go

go 1.20

require (
	github.com/asg017/sqlite-hello/go v0.0.0-00010101000000-000000000000
	github.com/mattn/go-sqlite3 v1.14.16
)

replace github.com/asg017/sqlite-hello/go => ../../bindings/go
