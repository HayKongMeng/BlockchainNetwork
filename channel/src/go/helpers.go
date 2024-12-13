package main

import (
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// Marshal helper converts an object to JSON byte array
func Marshal(data interface{}) ([]byte, error) {
	return json.Marshal(data)
}

// UnmarshalAsset helper converts JSON byte array to Asset struct
func UnmarshalAsset(data []byte) (*Asset, error) {
	var asset Asset
	err := json.Unmarshal(data, &asset)
	return &asset, err
}

// UnmarshalReportIssue helper converts JSON byte array to ReportIssue struct
func UnmarshalReportIssue(data []byte) (*ReportIssue, error) {
	var report ReportIssue
	err := json.Unmarshal(data, &report)
	return &report, err
}

// PutState helper stores data in the ledger by key
func PutState(ctx contractapi.TransactionContextInterface, key string, value interface{}) error {
	data, err := Marshal(value)
	if err != nil {
		return fmt.Errorf("failed to marshal data: %v", err)
	}
	return ctx.GetStub().PutState(key, data)
}

// GetState helper retrieves data from the ledger by key
func GetState(ctx contractapi.TransactionContextInterface, key string) ([]byte, error) {
	return ctx.GetStub().GetState(key)
}