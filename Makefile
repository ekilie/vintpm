VERSION=0.1.2

build:
	make build_android
	make build_linux
	make build_windows
	make build_mac

build_linux:
	@echo 'building linux binary...'
	env GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o vint
	@echo 'shrinking binary...'
	./upx --brute vint
	@echo 'zipping build...'
	tar -zcvf binaries/vintpm_linux_amd64.tar.gz vint
	@echo 'cleaning up...'
	rm vint

build_windows:
	@echo 'building windows executable...'
	env GOOS=windows GOARCH=amd64 go build -ldflags="-s -w" -o vint_windows_amd64.exe
	@echo 'shrinking build...'
	./upx --brute binaries/vintpm_windows_amd64.exe

build_mac:
	@echo 'building mac binary...'
	env GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w" -o vint
	@echo 'shrinking binary...'
	./upx --brute vint
	@echo 'zipping build...'
	tar -zcvf binaries/vintpm_mac_amd64.tar.gz vint
	@echo 'cleaning up...'
	rm vint

build_android:
	@echo 'building android binary'
	env GOOS=android GOARCH=arm64 go build -ldflags="-s -w" -o vint
	@echo 'zipping build...'
	tar -zcvf binaries/vintpm_android_arm64.tar.gz vint
	@echo 'cleaning up...'
	rm vint

build_test:
	go build -ldflags="-s -w" -o vint

dependencies:
	@echo 'checking dependencies...'
	go mod tidy

test:
	@echo -e '\nTesting Lexer...'
	@./gotest --format testname ./lexer/ 
	@echo -e '\nTesting Parser...'
	@./gotest --format testname ./parser/
	@echo -e '\nTesting AST...'
	@./gotest --format testname ./ast/
	@echo -e '\nTesting Object...'
	@./gotest --format testname ./object/
	@echo -e '\nTesting Evaluator...'
	@./gotest --format testname ./evaluator/

clean:
	go clean