package main

import (
	"log"
	"os"

	"github.com/cloudflare/cloudflare-go"
)

func main() {
	// Validate
	err := validate()
	if err != nil {
		log.Fatal(err.Error() + "\n")
		return
	}

	// Get IP address
	ip, err := getIp()
	if err != nil {
		log.Fatal(err.Error() + "\n")
		return
	}

	// Init CloudFlare API
	api, err := cloudflare.NewWithAPIToken(os.Getenv("CF_API_TOKEN"))
	if err != nil {
		log.Fatal("Could not initialize CloudFlare API.\n")
		return
	}

	// Initialize DNS record
	record := cloudflare.DNSRecord{
		Type: "A",
		Name: os.Getenv("CF_RECORD_NAME"),
	}

	// Search for existing DNS record
	records, err := api.DNSRecords(os.Getenv("CF_ZONE_ID"), record)
	if err != nil {
		log.Fatal(err)
		return
	}

	if len(records) > 0 {
		// Update existing record
		record = records[0]
		record.Content = ip

		err := api.UpdateDNSRecord(os.Getenv("CF_ZONE_ID"), record.ID, record)
		reportResult("update", err)
	} else {
		// Create new record
		record.Content = ip
		record.Proxiable = true
		record.Proxied = false

		_, err := api.CreateDNSRecord(os.Getenv("CF_ZONE_ID"), record)
		reportResult("create", err)
	}
}

/**
 * Report result
 */
func reportResult(action string, e error) {
	if e != nil {
		log.Fatal("Was not able to " + action + " DNS record.\n" + e.Error() + "\n")
	} else {
		log.Println("Successfully " + action + "d DNS record.")
	}
}
