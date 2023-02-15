PWD=$(shell pwd)
COVERAGE_DIR=coverage/
UNIT_TEST_COVERAGE_DIR=$(COVERAGE_DIR)unit/
COMPONENT_TEST_COVERAGE_DIR=$(COVERAGE_DIR)/component/
MERGED_TEST_COVERAGE_DIR=$(COVERAGE_DIR)merged/
BINARY_NAME=bin/binarycov

coverage_dir:
	@mkdir -p $(UNIT_TEST_COVERAGE_DIR)
	@mkdir -p $(COMPONENT_TEST_COVERAGE_DIR)
	@mkdir -p $(MERGED_TEST_COVERAGE_DIR)

unit_test_coverage: coverage_dir
	CGO_ENABLED=0 go test -cover ./... -args -test.gocoverdir=$(PWD)/$(UNIT_TEST_COVERAGE_DIR)

build_coverage: coverage_dir
	@go build -cover  -v -o $(BINARY_NAME) *.go

component_test_coverage: build_coverage
	GOCOVERDIR=$(COMPONENT_TEST_COVERAGE_DIR) $(BINARY_NAME)

merge_coverage: component_test_coverage unit_test_coverage
	@go tool covdata merge -i=$(UNIT_TEST_COVERAGE_DIR),$(COMPONENT_TEST_COVERAGE_DIR) -o $(MERGED_TEST_COVERAGE_DIR)
	@go tool covdata percent -i=$(MERGED_TEST_COVERAGE_DIR) -o $(MERGED_TEST_COVERAGE_DIR)coverage_percent.out
	@go tool covdata textfmt -i=$(MERGED_TEST_COVERAGE_DIR) -o $(MERGED_TEST_COVERAGE_DIR)coverage_textfmt.out

reproduce:
	docker run --rm -v $(PWD):/usr/src/myapp -w /usr/src/myapp golang:1.20 make merge_coverage
	cat $(MERGED_TEST_COVERAGE_DIR)coverage_percent.out
	cat $(MERGED_TEST_COVERAGE_DIR)coverage_textfmt.out

