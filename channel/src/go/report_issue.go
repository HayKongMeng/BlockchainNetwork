package main

import (
	"encoding/json"
	"fmt"
	"time"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type ReportIssue struct {
	ReportID   string `json:"report_id"`
	FullName   string `json:"full_name"`
	AssetName  string `json:"asset_name"`
	Problem    string `json:"problem"`
	Attachment string `json:"attachment"`
	UserID     string `json:"user_id"`
	Username   string `json:"username"`
	CreatedAt  string `json:"created_at"`
}


// CreateReportIssue adds a new report issue to the ledger based on asset availability and existence of assetID and assetName
func (s *SmartContract) CreateReportIssue(ctx contractapi.TransactionContextInterface, reportID, assetID, assetName, problem, attachment, userID, username string) (*ReportIssue, error) {

	// Check if the asset exists in the ledger
	assetData, err := ctx.GetStub().GetState(assetID)
	if err != nil || assetData == nil {
		return nil, fmt.Errorf("asset with ID %s does not exist", assetID)
	}

	// Unmarshal the asset data
	var asset Asset
	err = json.Unmarshal(assetData, &asset)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal asset data: %v", err)
	}

	// Verify that the asset name matches
	if asset.AssetName != assetName {
		return nil, fmt.Errorf("asset name %s does not match the provided asset ID %s", assetName, assetID)
	}

	// Create a new ReportIssue instance
	report := ReportIssue{
		ReportID:   reportID,
		AssetName:  asset.AssetName,
		Problem:    problem,
		Attachment: attachment,
		UserID:     userID,
		Username:   username,
		CreatedAt:  time.Now().String(),
	}

	// Save the report issue to the ledger
	reportKey := reportID
	if err := PutState(ctx, reportKey, report); err != nil {
		return nil, fmt.Errorf("failed to create report issue: %v", err)
	}

	return &report, nil
}

// QueryReportIssue retrieves a report issue by ID
func (s *SmartContract) QueryReportIssue(ctx contractapi.TransactionContextInterface, reportID string) (*ReportIssue, error) {
	data, err := GetState(ctx, reportID)
	if err != nil || data == nil {
		return nil, fmt.Errorf("report issue %s does not exist", reportID)
	}
	return UnmarshalReportIssue(data)
}

func (s *SmartContract) UpdateReportIssue(ctx contractapi.TransactionContextInterface, reportID, assetName, problem, attachment, userID, username string) (*ReportIssue, error) {
    // Retrieve the existing report issue by reportID
    report, err := s.QueryReportIssue(ctx, reportID)
    if err != nil {
        return nil, fmt.Errorf("failed to query report issue: %v", err)
    }

    // Update the report issue fields with new values
    report.AssetName = assetName
    report.Problem = problem
    report.Attachment = attachment
    report.UserID = userID
    report.Username = username

	if err := PutState(ctx, reportID, report); err != nil {
        return nil, fmt.Errorf("failed to update report issue in ledger: %v", err)
    }
    return report, nil
}


// DeleteReportIssue removes a report issue from the ledger
func (s *SmartContract) DeleteReportIssue(ctx contractapi.TransactionContextInterface, reportID string) error {
	return ctx.GetStub().DelState(reportID)
}

// GetReportIssueHistory retrieves the historical changes of a specific report issue by reportID
func (s *SmartContract) GetReportIssueHistory(ctx contractapi.TransactionContextInterface, reportID string) ([]*ReportIssue, error) {
	resultsIterator, err := ctx.GetStub().GetHistoryForKey(reportID)
	if err != nil {
		return nil, fmt.Errorf("failed to get report issue history: %v", err)
	}
	defer resultsIterator.Close()

	var history []*ReportIssue
	for resultsIterator.HasNext() {
		response, err := resultsIterator.Next()
		if err != nil {
			return nil, fmt.Errorf("failed to iterate through report issue history: %v", err)
		}

		var report *ReportIssue
		if response.IsDelete {
			report = &ReportIssue{ReportID: reportID}
		} else {
			report, err = UnmarshalReportIssue(response.Value)
			if err != nil {
				return nil, fmt.Errorf("failed to unmarshal report issue history: %v", err)
			}
		}
		history = append(history, report)
	}

	return history, nil
}

func (s *SmartContract) QueryAllReportIssues(ctx contractapi.TransactionContextInterface) ([]*ReportIssue, error) {
    // Retrieve all report issues using a key range that covers all possible keys
    resultsIterator, err := ctx.GetStub().GetStateByRange("", "~")
    if err != nil {
        return nil, fmt.Errorf("failed to get all report issues: %v", err)
    }
    defer resultsIterator.Close()

    var reports []*ReportIssue
    for resultsIterator.HasNext() {
        queryResponse, err := resultsIterator.Next()
        if err != nil {
            return nil, fmt.Errorf("failed to iterate over report issues: %v", err)
        }
    
        fmt.Printf("Raw data from ledger: %s\n", string(queryResponse.Value)) // Log raw data
    
        // Unmarshal the record into a ReportIssue struct
        report, err := UnmarshalReportIssue(queryResponse.Value)
        if err != nil {
            fmt.Printf("Skipping invalid report issue record: %s, error: %v\n", string(queryResponse.Value), err)
            continue 
        }
    
        if report.ReportID == "" || report.AssetName == "" {
            fmt.Printf("Skipping invalid report: %s, missing required fields\n", string(queryResponse.Value))
            continue
        }
    
        reports = append(reports, report)
    }
     if len(reports) == 0 {
        fmt.Println("No report issues found.")
    } else {
        fmt.Printf("Found %d report issues.\n", len(reports))
    }

    return reports, nil
}